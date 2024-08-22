#!/bin/bash

# Verifica se o namespace foi fornecido como argumento
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <namespace>"
    exit 1
fi

namespace=$1

# Função para converter valores de memória para MiB
convert_to_mib() {
    local value=$1
    if [[ $value == *Gi ]]; then
        echo $((${value%Gi} * 1024))
    elif [[ $value == *Mi ]]; then
        echo ${value%Mi}
    else
        echo $value
    fi
}

# Cabeçalho da tabela
printf "%-30s %-15s %-15s %-15s %-15s\n" "Pod Name" "Memory Usage" "Memory Requests" "Memory Limits" "Memory Waste"
printf "%-30s %-15s %-15s %-15s %-15s\n" "--------" "-------------" "----------------" "-------------" "-------------"

total_waste=0

# Obtém a lista de pods no namespace com status Running
pods=$(kubectl get pods -n "$namespace" --field-selector=status.phase=Running -o jsonpath="{.items[*].metadata.name}")

# Itera sobre os pods
for pod in $pods; do
    # Obtém as informações de memória para o pod
    usage=$(kubectl top pod "$pod" -n "$namespace" --no-headers | awk '{print $3}')
    
    # Obtém os detalhes do pod em formato JSON
    json=$(kubectl get pod "$pod" -n "$namespace" -o json)
    
    # Extrai solicitações e limites de memória
    requests=$(echo "$json" | jq -r '.spec.containers[].resources.requests.memory')
    limits=$(echo "$json" | jq -r '.spec.containers[].resources.limits.memory')
    
    # Converte o uso de memória para MiB
    usage_mib=$(echo "$usage" | sed 's/Mi$//g')
    requests_mib=$(convert_to_mib $requests)
    limits_mib=$(convert_to_mib $limits)
    
    # Calcula o desperdício de memória
    waste=$((requests_mib - usage_mib))
    total_waste=$((total_waste + waste))
    
    # Imprime a linha da tabela
    printf "%-30s %-15s %-15s %-15s %-15s\n" "$pod" "$usage" "${requests_mib}Mi" "${limits_mib}Mi" "${waste}Mi"
done

# Imprime o total de desperdício
printf "%-30s %-15s %-15s %-15s %-15s\n" "TOTAL" "-" "-" "-" "${total_waste}Mi"

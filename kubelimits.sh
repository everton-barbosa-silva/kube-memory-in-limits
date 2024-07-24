NAMESPACE="$1"

# Print the header
printf "%-30s\t%-15s\t%-15s\t%-15s\n" "Pod Name" "Memory Usage" "Memory Requests" "Memory Limits"

# Initialize line counter
line_count=0

# Iterate over each pod in the namespace
for pod in $(kubectl get pods -n $NAMESPACE -o name); do
  POD_NAME=$(echo $pod | cut -d'/' -f 2)
  POD_NAME_TRUNC=$(echo $POD_NAME | cut -c1-30)
  MEMORY_USAGE=$(kubectl top pod $POD_NAME -n $NAMESPACE --no-headers | awk '{print $3}')
  MEMORY_REQUESTS=$(kubectl get pod $POD_NAME -n $NAMESPACE -o=jsonpath='{.spec.containers[*].resources.requests.memory}')
  MEMORY_LIMITS=$(kubectl get pod $POD_NAME -n $NAMESPACE -o=jsonpath='{.spec.containers[*].resources.limits.memory}')

  # Format memory values to align units
  if [[ $MEMORY_USAGE == *Mi ]]; then
    MEMORY_USAGE=$(echo $MEMORY_USAGE | awk '{printf "%.2f Mi", $1}')
  elif [[ $MEMORY_USAGE == *Ki ]]; then
    MEMORY_USAGE=$(echo $MEMORY_USAGE | awk '{printf "%.2f Ki", $1}')
  elif [[ $MEMORY_USAGE == *Gi ]]; then
    MEMORY_USAGE=$(echo $MEMORY_USAGE | awk '{printf "%.2f Gi", $1}')
  fi

  if [[ $MEMORY_REQUESTS == *Mi ]]; then
    MEMORY_REQUESTS=$(echo $MEMORY_REQUESTS | awk '{printf "%.2f Mi", $1}')
  elif [[ $MEMORY_REQUESTS == *Ki ]]; then
    MEMORY_REQUESTS=$(echo $MEMORY_REQUESTS | awk '{printf "%.2f Ki", $1}')
  elif [[ $MEMORY_REQUESTS == *Gi ]]; then
    MEMORY_REQUESTS=$(echo $MEMORY_REQUESTS | awk '{printf "%.2f Gi", $1}')
  fi

  if [[ $MEMORY_LIMITS == *Mi ]]; then
    MEMORY_LIMITS=$(echo $MEMORY_LIMITS | awk '{printf "%.2f Mi", $1}')
  elif [[ $MEMORY_LIMITS == *Ki ]]; then
    MEMORY_LIMITS=$(echo $MEMORY_LIMITS | awk '{printf "%.2f Ki", $1}')
  elif [[ $MEMORY_LIMITS == *Gi ]]; then
    MEMORY_LIMITS=$(echo $MEMORY_LIMITS | awk '{printf "%.2f Gi", $1}')
  fi

  # Print the details in a formatted way
  printf "%-30s\t%-15s\t%-15s\t%-15s\n" "$POD_NAME_TRUNC" "$MEMORY_USAGE" "$MEMORY_REQUESTS" "$MEMORY_LIMITS"

  # Increment the line counter
  ((line_count++))
done

# Print the line count
echo -e "\nTotal number of pods: ${line_count}"
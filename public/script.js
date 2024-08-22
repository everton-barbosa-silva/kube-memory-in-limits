document.getElementById('namespace-form').addEventListener('submit', async function(event) {
    event.preventDefault();
    const namespace = document.getElementById('namespace-input').value;
    if (!namespace) return;
    
    document.getElementById('loading').style.display = 'block';
    document.getElementById('output').innerHTML = '';

    try {
        const response = await fetch(`/memory-usage?namespace=${namespace}`);
        const data = await response.json();

        let outputHTML = `
            <table>
                <tr>
                    <th>Nome do Pod</th>
                    <th>Uso de Memória</th>
                    <th>Solicitação de Memória</th>
                    <th>Limite de Memória</th>
                    <th>Desperdício de Memória</th>
                </tr>
        `;

        data.forEach(row => {
            outputHTML += `
                <tr>
                    <td>${row.podName}</td>
                    <td>${row.memoryUsage}</td>
                    <td>${row.memoryRequests}</td>
                    <td>${row.memoryLimits}</td>
                    <td>${row.memoryWaste}</td>
                </tr>
            `;
        });

        outputHTML += '</table>';
        document.getElementById('output').innerHTML = outputHTML;
    } catch (error) {
        document.getElementById('output').innerHTML = 'Erro ao buscar dados.';
    } finally {
        document.getElementById('loading').style.display = 'none';
    }
});

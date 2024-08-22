const express = require('express');
const { exec } = require('child_process');

const app = express();
const PORT = 8080;

app.use(express.static('public'));

app.get('/memory-usage', (req, res) => {
    const {namespace} = req.query;
    if (!namespace) {
        return res.status(400).json({ error: 'Namespace is required' });
    }

    exec(`./server/script.sh ${namespace}`, (error, stdout, stderr) => {
        if (error) {
            console.error(`exec error: ${error}`);
            return res.status(500).json({ error: 'Internal Server Error' });
        }

        const data = stdout.trim().split('\n').slice(1).map(line => {
            const [podName, memoryUsage, memoryRequests, memoryLimits, memoryWaste] = line.split(/\s+/);
            return { podName, memoryUsage, memoryRequests, memoryLimits, memoryWaste };
        });

        res.json(data);
    });
});

app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});

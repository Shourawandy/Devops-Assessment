const express = require('express');
const app = express();
const PORT = process.env.PORT || 8080;

// Simulated DB config read from env vars (populated via K8s Secret/ConfigMap)
const dbHost = process.env.DB_HOST || 'not-configured';

app.get('/', (req, res) => {
  res.send('Application is running');
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

// ADD THIS NEW ENDPOINT
app.get('/api/backend-status', (req, res) => {
  res.status(200).json({
    backend: {
      status: 'ok'
    }
  });
});

// Existing endpoint
app.get('/api/info', (req, res) => {
  res.status(200).json({
    service: 'backend',
    dbHost,
    time: new Date().toISOString()
  });
});

app.listen(PORT, () => {
  console.log(`Backend listening on port ${PORT}`);
});

module.exports = app;

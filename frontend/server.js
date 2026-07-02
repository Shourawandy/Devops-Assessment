const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

// Backend URL is injected via env var (K8s Service DNS name in-cluster)
const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:8080';

app.use(express.static(path.join(__dirname, 'public')));

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

// Proxy-ish endpoint so the browser doesn't need the internal backend URL
app.get('/api/backend-status', async (req, res) => {
  try {
    const response = await fetch(`${BACKEND_URL}/health`);
    const data = await response.json();
    res.status(200).json({ backend: data });
  } catch (err) {
    res.status(502).json({ error: 'backend unreachable', details: err.message });
  }
});

app.listen(PORT, () => {
  console.log(`Frontend listening on port ${PORT}, backend at ${BACKEND_URL}`);
});

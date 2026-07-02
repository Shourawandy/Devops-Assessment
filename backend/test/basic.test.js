const http = require('http');
const app = require('../server');

// Very small smoke test without extra test framework dependency.
// Exits with non-zero code on failure so CI can detect it.

const server = app.listen(0, () => {
  const port = server.address().port;

  http.get(`http://localhost:${port}/health`, (res) => {
    let data = '';
    res.on('data', (chunk) => (data += chunk));
    res.on('end', () => {
      const body = JSON.parse(data);
      if (res.statusCode === 200 && body.status === 'ok') {
        console.log('PASS: /health returned ok');
        server.close();
        process.exit(0);
      } else {
        console.error('FAIL: /health did not return expected response');
        server.close();
        process.exit(1);
      }
    });
  }).on('error', (err) => {
    console.error('FAIL:', err.message);
    process.exit(1);
  });
});

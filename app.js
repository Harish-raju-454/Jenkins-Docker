cat > app.js <<'EOF'
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send(`Hello from ${process.env.NODE_ENV || process.env.ENVIRONMENT || 'unknown'} environment!`);
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
EOF

const Express = require('express');

const PORT = process.env.PORT || 3000;

const app = new Express();

app.get('/', (req, res) => {
  res.send('Hello Kitty!');
});

app.listen(PORT, err => {
  if (err) {
    console.error(err);
    process.exit(1);
  }
  console.log(`Listen on port ${PORT}`);
});

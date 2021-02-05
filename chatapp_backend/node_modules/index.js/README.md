# index.js

Module loader

## Installation

    npm install index.js

## Usage

Example directory structure

    models
    ├── index.js
    ├── user.js
    └── blog.js

In index.js

    module.exports = require('index.js')(__dirname);

Models will automatically loaded

    var models = require('./models');
    models.user == require('./models/user');

## License

MIT

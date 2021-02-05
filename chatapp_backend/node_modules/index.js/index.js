var fs = require('fs'),
    path = require('path');

var exports = module.exports = function(dir, options) {
    var modules = {};
    options = merge(options || {}, {
        lazy: true
    });

    fs.readdirSync(dir).forEach(function(filename) {
        // filter index and dotfiles
        if (filename !== 'index.js' && filename[0] !== '.') {
            var moduleName = path.basename(filename, path.extname(filename));
            var modulePath = path.join(dir, moduleName);
            // lazy load
            if (options.lazy) {
                Object.defineProperty(modules, moduleName, {
                    get: function() {
                        return require(modulePath);
                    }
                });
            } else {
                modules[moduleName] = require(modulePath);
            }
        }
    });

    return modules;
};

function merge(obj, src) {
    for (var key in src) {
        if (src.hasOwnProperty(key) && obj[key] === undefined) {
            obj[key] = src[key];
        }
    }
    return obj;
}

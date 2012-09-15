#!/bin/bash

## copied from chaplinjs

command -v coffee > /dev/null 2>&1 || { echo "CoffeeScript needs to be installed using `npm install -g coffee`" >&2; exit 1; }
command -v r.js > /dev/null 2>&1 || { echo "RequireJS needs to be installed using `npm install -g requirejs`" >&2; exit 1; }

coffee --compile --bare --output ../js ../coffee/

r.js -o rjs-config.js out=../dist/wisk-rjs.js optimize=none
<<<<<<< HEAD
##r.js -o rjs-config.js out=../dist/wisk-rjs.min.js optimize=uglify

##gzip -9 -c ../dist/wisk-rjs.min.js > ../dist/wisk-rjs.min.js.gz
=======
#r.js -o rjs-config.js out=../dist/wisk-rjs.min.js optimize=uglify

#gzip -9 -c ../dist/wisk-rjs.min.js > ../dist/wisk-rjs.min.js.gz
>>>>>>> master

#rm -r js

var config = module.exports;

config['browser-all'] = {
  autoRun: false,
  environment: 'browser',
  rootPath: '../',
  libs: [
    'js/vendor/require-2.0.4.js', 
    'examples/data/sample_data.js',
    'js/vendor/underscore-1.3.3.js',
    'js/vendor/d3.v2.js'
    //'js/dist/wisk-rjs.js'
    

  ],
  //resources:['js/utils.js'],
  sources: [
    'js/*.js'
  ],
  tests: ['test/*-tests.js'],
  extensions: [require('buster-amd')]
};
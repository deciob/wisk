
var config = module.exports;

config['browser-all'] = {
  autoRun: false,
  environment: 'browser',
  rootPath: '../',
  libs: [
    'examples/data/sample_data.js',
    'js/vendor/require-2.0.4.js', 
    'js/vendor/d3.v2.js'
  ],
  sources: [
    'js/*.js'
  ],
  tests: ['test/*-tests.js'],
  extensions: [require('buster-amd')]
};
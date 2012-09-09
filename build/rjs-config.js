//({
//  baseUrl: './',     // relative to appDir
//  appDir: "../js/",  // copy from
//  dir: "dist",       // to
//  //wrap: true,
//  modules: [
//    {
//      name: "wisk"
//    }
//  ],
//  paths: {
//    // libraries path
//    "d3": "vendor/d3.v2"
//  }
//})

({
    baseUrl: '../js',                         
    name: 'vendor/almond',
    include: ['vendor/d3.v2', 'wisk'],
    //insertRequire: ['wisk'],
    //out: '../dist/wisk-built.js',
    //wrap: true
})

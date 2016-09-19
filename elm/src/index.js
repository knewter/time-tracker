'use strict';

require('./index.html');
var Elm = require('./Main');

var app = Elm.Main.fullscreen();

app.ports.storeApiKey.subscribe(function(data){
  localStorage.setItem('apiKey', data);
});

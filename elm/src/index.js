'use strict';

require('./index.html');
var Elm = require('./Main');

var apiKey = localStorage.getItem('apiKey');

var app;

if(apiKey){
  app = Elm.Main.fullscreen({apiKey: apiKey});
} else {
  app = Elm.Main.fullscreen({apiKey: null});
}

app.ports.storeApiKey.subscribe(function(data){
  localStorage.setItem('apiKey', data);
});

'use strict'

require('./index.html')
let Elm = require('./Main')

let apiKey = localStorage.getItem('apiKey')

let app

if(apiKey){
  app = Elm.Main.fullscreen({apiKey: apiKey})
} else {
  app = Elm.Main.fullscreen({apiKey: null})
}

app.ports.storeApiKey.subscribe(function(data){
  localStorage.setItem('apiKey', data)
});

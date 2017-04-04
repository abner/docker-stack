import * as express from 'express';

let http = require('http');
let reload = require('reload');
let app = express()

app.set('port', process.env.PORT || 3000)

app.get('/', function (req, res) {
  res.send(`
  <script src="/reload/reload.js"></script>
  <h1>Hello World 2</h1>`)
})


let server = http.createServer(app)

server.listen(app.get('port'), function(){
  console.log("Web server listening on port " + app.get('port'));
});

reload(server, app)
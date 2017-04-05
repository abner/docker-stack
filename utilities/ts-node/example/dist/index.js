"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var express = require("express");
var http = require('http');
var reload = require('reload');
var app = express();
app.set('port', process.env.PORT || 3000);
app.get('/', function (req, res) {
    res.send("\n  <script src=\"/reload/reload.js\"></script>\n  <h1>Hello World</h1>");
});
var server = http.createServer(app);
server.listen(app.get('port'), function () {
    console.log("Web server listening on port " + app.get('port'));
});
reload(server, app);

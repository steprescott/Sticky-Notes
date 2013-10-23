
/**
 * Module dependencies.
 */

var express = require('express');
var http = require('http');
var path = require('path');
var router = require('./router');
var config = require('./config');

var app = express();

// all environments
app.set('port', config.BIND_PORT);
app.use(express.logger('dev'));
app.use(express.bodyParser());
app.use(express.methodOverride());

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

// Start the router that deals with all requests
router.requestHandler(express, app);

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});

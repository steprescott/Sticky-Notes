var express = require('express');
var http = require('http');
var httpRouter = require('./api/http');
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

// Start sequelize
require("./orm").setup('./models', config.MYSQL_DATABASE, config.MYSQL_USERNAME, config.MYSQL_PASSWORD, {
    host: config.MYSQL_HOST,
    port: config.MYSQL_PORT
});

// Start the router that deals with all requests
httpRouter.requestHandler(express, app);

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});

var userModel = require('../models/userModel');
exports.getUserData = function(req, res){

    // does not care about the user id yet
    var user = userModel.getUserData(1234);
    res.send(200, user);
};

exports.loginRequest = function(req, res){

    res.send(201, 'Well done you are logged in');
};
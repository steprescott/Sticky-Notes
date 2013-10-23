
/*
 * GET home page.
 */

exports.getUserData = function(req, res){
  res.send({user: 'data'});
};

exports.loginRequest = function(req, res){
    res.send(201, 'Well done you are logged in');
};
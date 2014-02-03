var orm = require('../orm');
var crypto = require('crypto');

exports.createSession = function(userID, callback)
{
    var sessionModel = orm.model('Session');
    // Gives us some real entropy: http://stackoverflow.com/a/14869745
    var token = crypto.randomBytes(64).toString('hex');

    sessionModel.build({
        token: token,
        user: userID
    }).save().error(function(err)
        {
            return callback(err);
        }).success(function(session)
        {
            return callback(null, session);
        });
};

exports.getSessionByToken = function(token, callback)
{
    var sessionModel = orm.model('Session');

    sessionModel.find({
        where: { token: token }
    }).error(function(err)
        {
            return callback(err);
        }).success(function(session)
        {
            return callback(null, session);
        });
};
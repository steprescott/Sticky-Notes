var orm = require('../orm');

exports.getUserByID = function(userID, callback)
{
    var userModel = orm.model('User');
    userModel.find({ where: {id: userID} }).error(function (err)
    {
        return callback(err);
    }).success(function (user)
        {
            return callback(null, user);
        });
};

exports.getUserByEmail = function(email, callback)
{
    var userModel = orm.model('User');
    userModel.find({ where: {email: email} }).error(function (err)
    {
        return callback(err);
    }).success(function (user)
        {
            return callback(null, user);
        });
};

exports.createUser = function(firstName, surname, email, hashedPassword, callback)
{
    var userModel = orm.model('User');

    userModel.build({
        firstName: firstName,
        surname: surname,
        email: email,
        password: hashedPassword})
        .save().error(function(err)
        {
            return callback(err);
        }).success(function(user)
        {
            return callback(null, user);
        });
};
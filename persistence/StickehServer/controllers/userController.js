var orm = require('../orm');
var passwordHash = require('password-hash');

exports.getUserData = function (req, res) {
    var id = req.params.id;

    var userModel = orm.model('User');
    userModel.find({ where: {id: id} }).error(function (err) {

        // error callback
    }).success(function (user) {
            if (!user)
            {
                res.send(401, 'Unknown ID');
            }

            res.send(200, user);
        });
};

exports.loginRequest = function (req, res) {

    var username = req.body.username;
    var password = req.body.password;

    var userModel = orm.model('User');
    userModel.find({ where: {email: username} }).error(function (err) {
        // error callback
    }).success(function (user) {
	console.log(user);
            if (!user)
            {
                res.send(403, 'Invalid credentials');
                return;
            }

            if (!passwordHash.verify(password, user.dataValues.password))
            {
                res.send(403, 'Invalid credentials');
                return;
            }

            var session =
            {
                id: 12345,
                created: new Date()
            }

            var result =
            {
                session: session,
                user: user
            }

            res.send(200, result);
        });
};

exports.registerUserRequest = function(req, res){
    var userModel = orm.model('User');
    var firstName = req.body.firstName;
    var surname = req.body.surname;
    var password = req.body.password;
    var email = req.body.email;

    var hashedPassword = passwordHash.generate(password, {algorithm: 'sha512'});

    console.log(hashedPassword);
    // TODO: validation before saving
    userModel.build({
        firstName: firstName,
        surname: surname,
        email: email,
        password: hashedPassword})
        .save()
        .success(function() {

            res.send(201, 'User successfully registered');

        }).error(function(err) {
            res.send(500, "Error registering user");
        });
}
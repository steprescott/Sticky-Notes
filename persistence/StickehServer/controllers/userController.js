var orm = require('../orm');

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

            // todo: hashing
            if (user.dataValues.password !== password)
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

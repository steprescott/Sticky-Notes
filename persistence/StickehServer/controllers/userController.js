var orm = require('../orm');
var passwordHash = require('password-hash');
var crypto = require('crypto');

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
	var sessionModel = orm.model('Session');
	
	userModel.find({
		where: { email: username }
	}).error(function(err){
		res.send(500);
	}).success(function(user){
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

		// Gives us some real entropy: http://stackoverflow.com/a/14869745
		var token = crypto.randomBytes(64).toString('hex');
		sessionModel.build({
			token: token,
			user: user.id
		}).save();

		var result =
		{
			session:
			{
				id: token,
				created: new Date()
			},
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
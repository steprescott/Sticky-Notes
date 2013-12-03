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

    var inputValidationResult = validateRegistrationInput(email, password, firstName, surname);

    if (!inputValidationResult.valid)
    {
        res.send(400, inputValidationResult.message)
    }

	var hashedPassword = passwordHash.generate(password, {algorithm: 'sha512'});

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

function validateRegistrationInput(email, password, firstName, surname)
{
    var result = {
        valid: true,
        message: ""
    }

    var emailInputResult = validateEmailInput(email);

    if (!emailInputResult.valid)
    {
        result.valid = false;
        result.message = emailInputResult.message
        return result;
    }

    var passwordInputResult = validatePasswordInput(password);

    if (!passwordInputResult.valid)
    {
        result.valid = false;
        result.message = passwordInputResult.message
        return result;
    }

    var nameInputResult = validateName(firstName, surname);

    if (!nameInputResult.valid)
    {
        result.valid = false;
        result.message = nameInputResult.message
        return result;
    }

    return result;
}

function validateEmailInput(email)
{
    var result =
    {
        valid: true,
        message: ""
    }

    if (email == null || email == '')
    {
        result.message += 'Email supplied was blank.'
        result.valid = false;
        return result;
    }

    // Regex found on stack overflow validating email according to RFC 2822
    // Source: http://stackoverflow.com/a/1373724
    var re = /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/;

    if (!re.test(email))
    {
        result.message += 'Invalid email.';
        result.valid = false;
    }

    return result;
}

function validatePasswordInput(password)
{
    var result =
    {
        valid: true,
        message: ""
    }

    if (typeof password !== 'string' || password == null || password == '')
    {
        result.message += 'Invalid password.';
        result.valid = false;
        return result;
    }

    if (password.length < 8)
    {
        result.message += 'Password needs to be at least 8 characters long.';
        result.valid = false;
    }

    return result;
}

function validateName(firstName, surname)
{
    var result =
    {
        valid: true,
        message: ""
    }

    // These are optional fields, but just making sure they are strings
    if (typeof firstName !== 'string' || typeof surname !== 'string')
    {
        result.message += 'Invalid name';
        result.valid = false;
        return result;
    }

    return result;
}
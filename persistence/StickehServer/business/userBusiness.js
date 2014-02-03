var passwordHash = require('password-hash');

var userPersistence = require('../persistence/userPersistence');
var sessionPersistence = require('../persistence/sessionPersistence');

exports.onGetUserDataRequest = function (req, res)
{
	var id = req.params.id;

    userPersistence.getUserByID(id, userDataReturnedHandler);

    function userDataReturnedHandler(err, user)
    {
        if (err)
        {
            console.log(err);
            res.send(500, 'Error retrieving user data')
            return;
        }

        if (!user)
        {
            res.send(401, 'Unknown ID');
            return;
        }

        res.send(200, user);
    }
};

exports.onLoginRequest = function (req, res)
{
	var username = req.body.username;
	var password = req.body.password;

    userPersistence.getUserByEmail(username, userDataReturnedHandler);

    function userDataReturnedHandler(err, user)
    {
        if (err)
        {
            console.log(err);
            res.send(500, 'Error retrieving user data')
            return;
        }

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

        sessionPersistence.createSession(user.id, sessionSavedHandler)

        function sessionSavedHandler(err, session)
        {
            if (err)
            {
                console.log(err);
                res.send(500, 'Error setting up user session')
                return;
            }

            var result =
            {
                session:
                {
                    id: session.token,
                    created: new Date()
                },
                user: user
            }

            res.send(200, result);
        };

	};
};

exports.onRegisterUserRequest = function(req, res)
{
	var firstName = req.body.firstName;
	var surname = req.body.surname;
	var password = req.body.password;
	var email = req.body.email;

    var inputValidationResult = validateRegistrationInput(email, password, firstName, surname);

    if (!inputValidationResult.valid)
    {
        res.send(400, inputValidationResult.message);
        return;
    }

	var hashedPassword = passwordHash.generate(password, {algorithm: 'sha512'});

    userPersistence.createUser(firstName, surname, email, hashedPassword, userSavedHandler);

    function userSavedHandler(err, user)
    {
        if (err)
        {
            res.send(500, "Error registering user");
            return;
        }

        res.send(201, 'User successfully registered');
    }
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
        result.message = emailInputResult.message;
        return result;
    }

    var passwordInputResult = validatePasswordInput(password);

    if (!passwordInputResult.valid)
    {
        result.valid = false;
        result.message = passwordInputResult.message;
        return result;
    }

    var nameInputResult = validateName(firstName, surname);

    if (!nameInputResult.valid)
    {
        result.valid = false;
        result.message = nameInputResult.message;
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
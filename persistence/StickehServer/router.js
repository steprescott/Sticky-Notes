exports.requestHandler = function(express, app)
{
	var userController = require('./controllers/userController');
	var noteController = require('./controllers/noteController');
	app.use(app.router);

	// User operations
	app.get('/user/:id', userController.getUserData);
	app.post('/user/register', userController.registerUserRequest);
	app.post('/user/login', userController.loginRequest);

	// Note operations
	app.post('/notes/list', noteController.listNotesForUser);
	app.post('/notes/save', noteController.persistNote);
}
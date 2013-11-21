exports.requestHandler = function(express, app)
{
    var userController = require('./controllers/userController');
    var noteController = require('./controllers/noteController');
    app.use(app.router);

    //example of a get
    app.get('/user/:id', userController.getUserData);

    app.post('/api/login', userController.loginRequest);

    app.post('/notes/list', noteController.listNotesForUser);
    app.post('/notes/save', noteController.persistNote);

}
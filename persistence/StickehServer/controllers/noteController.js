var orm = require('../orm');
exports.listNotesForUser = function(req, res){
	var noteModel = orm.model('Note');
	var sessionModel = orm.model('Session');
	var token = req.body.token;

	// Query our session table with the auth token
	sessionModel.find({
		where: { token: token }
	}).error(function(error){
		res.send(500);
	}).success(function(session){
		if (!session)
		{
			res.send(500);
			return;
		}
		// Query our note table with the user id from the session
		noteModel.findAll({
			where: { author: session.user }
		}).error(function(err){
			res.send(500);
		}).success(function(notes){
			res.send(200, notes);
		});
	});
};

exports.persistNote = function(req, res){
	var noteModel = orm.model('Note');
	var sessionModel = orm.model('Session');	
	var body = req.body.body;
	var token = req.body.token;
	var created = new Date();
	
	// Query our session table with the auth token
	sessionModel.find({
		where: { token: token }
	}).error(function(error){
		res.send(500);
	}).success(function(session){
		if (!session)
		{
			res.send(500);
			return;
		}
		
		noteModel.build({
			body: body,
			created: created,
			author: session.user
		}).save().success(function(result){
			// Respond with the ID of the saved note
			res.send(201, result.dataValues.id);
		}).error(function(err) {
			res.send(500, "Error saving note");
		});
	});
};
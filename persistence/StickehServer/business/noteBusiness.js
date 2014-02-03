var sessionPersistence = require('../persistence/sessionPersistence');
var notePersistence = require('../persistence/notePersistence');

exports.onListNotesForUserRequest = function(req, res)
{
	var token = req.body.token;

    sessionPersistence.getSessionByToken(token, sessionDataReturnedHandler)

    function sessionDataReturnedHandler(err, session)
    {
        if (err)
        {
            res.send(500, 'Error getting session');
            return;
        }

        if (!session)
        {
            res.send(401, 'Unknown session');
            return;
        }

        notePersistence.findNotesByAuthor(session.user, notesReturnedHandler);

        function notesReturnedHandler(err, notes)
        {
            if (err)
            {
                res.send(500, 'Error retrieving notes');
                return;
            }

            res.send(200, notes);
        }
    }
};

exports.onPersistNoteRequest = function(req, res){
	var body = req.body.body;
	var token = req.body.token;

    sessionPersistence.getSessionByToken(token, sessionDataReturnedHandler)

    function sessionDataReturnedHandler(err, session)
    {
        if (err)
        {
            res.send(500, 'Error getting session');
            return;
        }

        if (!session)
        {
            res.send(401, 'Unknown session');
            return;
        }

        notePersistence.createNote(body, session.user, noteSavedHandler);

        function noteSavedHandler(err, note)
        {
            if (err)
            {
                res.send(500, 'Error saving note');
                return;
            }

            // Respond with the ID of the saved note
            res.send(201, note.dataValues.id);
        }
    }
};
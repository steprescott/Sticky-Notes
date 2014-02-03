var orm = require('../orm');

exports.findNotesByAuthor = function(userID, callback)
{
    var noteModel = orm.model('Note');

    noteModel.findAll({
        where: { author: userID }
    }).error(function(err)
        {
            return callback(err);
        }).success(function(notes)
        {
            return callback(null, notes);
        });
};

exports.createNote = function(body, userID, callback)
{
    var noteModel = orm.model('Note');

    noteModel.build({
        body: body,
        created: new Date(),
        author: userID
    }).save().error(function(err)
        {
            return callback(err);
        }).success(function(note)
        {
            return callback(null, note);
        });
}
var orm = require('../orm');
exports.listNotesForUser = function(req, res){

    var noteModel = orm.model('Note');

    var token = req.body.token; // currently the token is the user id

    // TODO: Should look at the session table, get the author id from there and then get the notes
    noteModel.findAll({ where: {author: token} }).error(function (err) {

        // error callback
    }).success(function (notes) {

            res.send(200, notes);
        });
};

exports.persistNote = function(req, res){
    var noteModel = orm.model('Note');
    var body = req.body.body;
    var author = req.body.author;
    var created = new Date();

    noteModel.build({body: body, created: created, author: author})
        .save()
        .success(function(result) {

            // Respond with the ID of the saved note
            res.send(201, result.dataValues.id);

        }).error(function(err) {
            res.send(500, "Error saving note");
        });
};
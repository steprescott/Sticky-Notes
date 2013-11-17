var orm = require('../orm');
exports.listNotesForUser = function(req, res){

    var noteModel = orm.model('note');

    // some mock data built using sequelize
    var notes =
        [
            noteModel.build({id:10000000001, body: "What is love", created: new Date(), author: 10000000001}),
            noteModel.build({id:10000000002, body: "baby don't hurt me", created: new Date(), author: 10000000001}),
            noteModel.build({id:10000000003, body: "don't hurt me", created: new Date(), author: 10000000001}),
            noteModel.build({id:10000000004, body: "no more", created: new Date(), author: 10000000001})
        ];


    res.send(200, notes);
};

exports.persistNote = function(req, res){
    var noteModel = orm.model('note');
    var body = req.body.body;
    var created = new Date();
    var author = 10000000001; // TODO: Get this value by checking the session token

    noteModel.build({body: body, created: created, author: author})
        .save()
        .success(function() {

            res.send(201, "note saved");

        }).error(function(err) {
            res.send(500, "Error saving note");
        });
};
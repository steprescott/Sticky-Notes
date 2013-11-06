var noteModel = require('../models/noteModel');
exports.listNotesForUser = function(req, res){

    // does not care about the user id yet
    var notes = noteModel.getNotesForUser(1234);

    res.send(200, notes);
};
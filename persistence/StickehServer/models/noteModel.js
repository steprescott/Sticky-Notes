/**
 * Created by Erik on 06/11/13.
 */
exports.getNotesForUser = function(userID)
{
    /*
    just a little cheat sheet from our models txt
     ----------------------
     Note
     ----------------------
     Id			Int(11)
     Body		Text
     Created		DateTime
     Author		Int FK User(11)

     */

    var notes =
        [
            {id:10000000001, body: "What is love", created: new Date(), author: 10000000001},
            {id:10000000002, body: "baby don't hurt me", created: new Date(), author: 10000000001},
            {id:10000000003, body: "don't hurt me", created: new Date(), author: 10000000001},
            {id:10000000004, body: "no more", created: new Date(), author: 10000000001}
        ];

    return notes;
}
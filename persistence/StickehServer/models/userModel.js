/**
 * Created by Erik on 06/11/13.
 */
exports.getUserData = function(userID)
{
    /*
     just a little cheat sheet from our models txt
     ----------------------
     User
     ----------------------
     id			Int(11)
     frstName	Text(255)
     surname		Text(255)
     email		Text(255)
     password	Text(255)

     */

    var user =
    {
        id:10000000001,
        firstName: 'Cool',
        surname: 'McRomance',
        email: 'test@testmail.com',
        password: 'superSecureHash%£^"'
    }

    return user;
}
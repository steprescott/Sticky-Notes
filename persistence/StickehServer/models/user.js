var orm = require("../orm")
    , Seq = orm.Seq();

//Creating our module
module.exports = {
    model:{
        id: Seq.INTEGER,
        firstName: Seq.STRING,
        surname: Seq.STRING,
        email: Seq.STRING,
        pssword: Seq.STRING
    },
    relations:{
        //hasOne: (user, {as: 'author'})
    },
    options:{
        freezeTableName: true
    }
}
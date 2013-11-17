var orm = require("../orm")
    , Seq = orm.Seq();

//Creating our module
module.exports = {
    model:{
        id: Seq.INTEGER,
        body: Seq.TEXT,
        created: Seq.DATE,
        author: Seq.INTEGER
    },
    relations:{
        //hasOne: (user, {as: 'author'})
    },
    options:{
        freezeTableName: true,
        timestamps: false
    }
}
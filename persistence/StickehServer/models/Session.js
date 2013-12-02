var orm = require("../orm");
var seq = orm.Seq();

module.exports = {
	model:
	{
		id:
		{
			type: seq.INTEGER,
			autoIncrement: true
		},
		token: seq.STRING,
		user: seq.INTEGER
	},
	relations:
	{
		//hasOne: (user, {as: 'author'})
	},
	options:
	{
		freezeTableName: true,
		timestamps: false
	}
};
package com.aespen.stickynotes.persistence;

import java.io.IOException;

//import de.greenrobot.daogenerator.DaoGenerator;
//import de.greenrobot.daogenerator.Entity;
//import de.greenrobot.daogenerator.Schema;

public class LocalRepository
{
	public void CreateSchema() throws IOException, Exception
	{
		//Schema schema = new Schema(1, "com.aespen.stickynotes.models");

		//Entity note = schema.addEntity("Note");
		//note.addIdProperty();

		//new DaoGenerator().generateAll(schema, "../DaoExample/src-gen");
	}
	
	public String SayHello()
	{
		return "hello";
	}
}

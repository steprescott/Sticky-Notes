package com.aespen.stickynotes.persistence;

import com.aespen.stickynotes.dao.DaoMaster;
import com.aespen.stickynotes.dao.DaoSession;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteOpenHelper;

public class DatabaseHandler extends SQLiteOpenHelper
{
	public DatabaseHandler(Context context, String name, CursorFactory factory, int version)
	{
		super(context, name, factory, version);
	}

	private DaoMaster daoMaster;
	private DaoSession daoSession;

	@Override
	public void onCreate(SQLiteDatabase database)
	{
		daoMaster = new DaoMaster(database);
		daoSession = daoMaster.newSession();
	}
	
	public DaoSession getCurrentSession()
	{
		return this.daoSession;
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion)
	{
		
	}
}

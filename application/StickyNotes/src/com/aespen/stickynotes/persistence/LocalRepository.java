package com.aespen.stickynotes.persistence;

import com.aespen.stickynotes.core.ServiceLocator;
import com.aespen.stickynotes.dao.DaoSession;

public class LocalRepository
{
	private DaoSession daoSession;
	
	private DaoSession getSession()
	{
		if (this.daoSession == null)
		{
			DatabaseHandler sessionManager = ServiceLocator.getService(DatabaseHandler.class);
			sessionManager.getWritableDatabase();
			this.daoSession = sessionManager.getCurrentSession();
		}
		
		return this.daoSession;
	}
	
	public String sayHello()
	{
		DaoSession session = this.getSession();
		
		return (session == null) ? "it's null" : "it's not null";
	}
}

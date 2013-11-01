package com.aespen.stickynotes.persistence;

import java.util.Date;

import com.aespen.stickynotes.core.ServiceLocator;
import com.aespen.stickynotes.dao.DaoSession;
import com.aespen.stickynotes.dao.Note;
import com.aespen.stickynotes.dao.NoteDao;

public class LocalRepository implements ILocalRepository
{
	private DaoSession daoSession;
	
	private DaoSession getSession()
	{
		if (this.daoSession == null)
		{
			DatabaseHandler databaseHandler = ServiceLocator.getService(DatabaseHandler.class);
			if (databaseHandler != null)
			{
				databaseHandler.getWritableDatabase(); // Create it
				this.daoSession = databaseHandler.getCurrentSession();
			}
		}
		
		return this.daoSession;
	}
	
	public String isSessionNull()
	{
		DaoSession session = this.getSession();
		
		return (session == null) ? "it's null" : "it's not null";
	}
	
	public boolean createNote(String text)
	{
		DaoSession session = this.getSession();
		if (session == null)
			return false;
		
		NoteDao noteDao = session.getNoteDao();
		
		Note note = new Note(null, text, new Date(), null);
		noteDao.insert(note);
		
		return true;
	}
}

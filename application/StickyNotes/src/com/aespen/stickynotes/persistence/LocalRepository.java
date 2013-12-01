package com.aespen.stickynotes.persistence;

import java.util.Date;
import java.util.List;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;

import com.aespen.stickynotes.dao.DaoMaster;
import com.aespen.stickynotes.dao.DaoSession;
import com.aespen.stickynotes.dao.Note;
import com.aespen.stickynotes.dao.NoteDao;
import com.aespen.stickynotes.dao.NoteDao.Properties;

public class LocalRepository implements ILocalRepository
{
	private DaoSession daoSession;
	private SQLiteDatabase db;
	private DaoMaster daoMaster;
	private DaoMaster.DevOpenHelper helper;

	public LocalRepository(Context applicationContext, String databaseName)
	{
		helper = new DaoMaster.DevOpenHelper(applicationContext, databaseName, null);
		db = helper.getWritableDatabase();
		daoMaster = new DaoMaster(db);
		daoSession = daoMaster.newSession();
	}

	public String isSessionNull()
	{
		DaoSession session = this.daoSession;

		return (session == null) ? "it's null" : "it's not null";
	}
	
	public void saveNote(Note note)
	{
		DaoSession session = this.daoSession;

		if (session == null)
			return;
		
		session.insertOrReplace(note);
	}

	public List<Note> getNotes()
	{
		DaoSession session = this.daoSession;

		if (session == null)
			return null;

		NoteDao noteDao = session.getNoteDao();
		return noteDao.queryBuilder().orderDesc(Properties.Created).list();
	}
	
	public List<Note> getNotesThatContain(String term)
	{
		DaoSession session = this.daoSession;

		if (session == null)
			return null;
		
		String queryTerm = String.format("%%%s%%", term);

		NoteDao noteDao = session.getNoteDao();
		return noteDao.queryBuilder().orderDesc(Properties.Created).where(Properties.Text.like(queryTerm)).list();
	}

	public boolean deleteNote(Note note)
	{
		DaoSession session = this.daoSession;

		if (session == null)
			return false;

		NoteDao noteDao = session.getNoteDao();
		noteDao.delete(note);
		return true;
	}
}

package com.aespen.stickynotes.persistence;

import java.util.List;

import com.aespen.stickynotes.dao.Note;

public interface ILocalRepository
{
	String isSessionNull();

	List<Note> getNotes();

	boolean deleteNote(Note note);
	
	List<Note> getNotesThatContain(String term);
	
	void saveNote(Note note);
}

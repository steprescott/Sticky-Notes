package com.aespen.stickynotes.persistence;

import java.util.List;

import com.aespen.stickynotes.dao.Note;

public interface ILocalRepository
{
	String isSessionNull();
	boolean createNote(String text);
	List<Note> getNotes();
}

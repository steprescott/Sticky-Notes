package com.aespen.stickynotes.persistence;

public interface ILocalRepository
{
	String isSessionNull();
	boolean createNote(String text);
}

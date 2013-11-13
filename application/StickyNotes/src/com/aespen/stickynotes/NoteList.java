package com.aespen.stickynotes;

import java.util.List;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.ListView;

import com.aespen.stickynotes.core.ServiceLocator;
import com.aespen.stickynotes.dao.Note;
import com.aespen.stickynotes.persistence.ILocalRepository;

public class NoteList extends Activity
{
	ILocalRepository localRepository;

	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		this.requestWindowFeature(Window.FEATURE_NO_TITLE);

		super.onCreate(savedInstanceState);

		this.setContentView(R.layout.activity_notelist);

		localRepository = ServiceLocator.getService(ILocalRepository.class);

		this.initialiseListeners();
	}

	protected void onResume()
	{
		super.onResume();

		List<Note> notes = localRepository.getNotes();
		ListView listView = (ListView) findViewById(R.id.notelist);
		listView.setAdapter(new NoteListNoteAdapter(this, R.layout.note_list_layout, notes));
	}

	protected void initialiseListeners()
	{
		Button newNoteButton = (Button) findViewById(R.id.addNote);
		newNoteButton.setOnClickListener(new View.OnClickListener()
		{
			@Override
			public void onClick(View v)
			{
				addNotePressed(v);
			}
		});
		
		Button createAccountButton = (Button) findViewById(R.id.createAccountButton);
		createAccountButton.setOnClickListener(new View.OnClickListener()
		{
			@Override
			public void onClick(View v)
			{
				createAccountPressed(v);
			}
		});
	}

	protected void addNotePressed(View v)
	{
		Intent i = new Intent(this, NoteCreate.class);
		startActivity(i);
	}
	
	protected void createAccountPressed(View v)
	{
		Intent i = new Intent(this, Login.class);
		startActivity(i);
	}
}

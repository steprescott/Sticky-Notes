package com.aespen.stickynotes;

import java.util.List;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemLongClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.aespen.stickynotes.core.ServiceLocator;
import com.aespen.stickynotes.dao.Note;
import com.aespen.stickynotes.persistence.ILocalRepository;

public class NoteList extends Activity
{
	ILocalRepository localRepository;
	private ListView noteListView;
	private NoteListNoteAdapter noteListNoteAdapter;
	private String filterCriteriaString = "";

	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		this.requestWindowFeature(Window.FEATURE_NO_TITLE);

		super.onCreate(savedInstanceState);

		this.setContentView(R.layout.activity_notelist);

		this.localRepository = ServiceLocator.getService(ILocalRepository.class);

		this.noteListNoteAdapter = new NoteListNoteAdapter(this, R.layout.note_list_layout);

		this.noteListView = (ListView) findViewById(R.id.notelist);
		this.noteListView.setAdapter(noteListNoteAdapter);

		this.initialiseListeners();
	}

	protected void refreshNotes()
	{
		List<Note> notes;
		if (this.filterCriteriaString.length() == 0)
		{
			notes = this.localRepository.getNotes();
		}
		else
		{
			notes = this.localRepository.getNotesThatContain(this.filterCriteriaString);
		}
		this.noteListNoteAdapter.clear();
		this.noteListNoteAdapter.addAll(notes);
	}

	protected void onResume()
	{
		super.onResume();

		this.refreshNotes();
	}

	protected void initialiseListeners()
	{
		Button newNoteButton = (Button) findViewById(R.id.addNote);
		newNoteButton.setOnClickListener(new View.OnClickListener()
		{
			public void onClick(View v)
			{
				addNotePressed(v);
			}
		});

		Button createAccountButton = (Button) findViewById(R.id.createAccountButton);
		createAccountButton.setOnClickListener(new View.OnClickListener()
		{
			public void onClick(View v)
			{
				createAccountPressed(v);
			}
		});
		
		TextView searchNotesTextView = (TextView) findViewById(R.id.searchNotes);
		searchNotesTextView.setOnKeyListener(new View.OnKeyListener()
		{
			public boolean onKey(View v, int keyCode, KeyEvent event)
			{
				TextView searchInput = (TextView) v;
				filterNotes(searchInput.getText().toString());
				return false;
			}
		});

		this.noteListView.setOnItemLongClickListener(new OnItemLongClickListener()
		{
			public boolean onItemLongClick(AdapterView<?> adapterView, View view, int pos, long id)
			{
				noteLongPressed(view, pos, id);
				return true;
			}
		});
	}
	
	protected void filterNotes(String filter)
	{
		this.filterCriteriaString = filter;
		this.refreshNotes();
	}

	protected void noteLongPressed(View view, int pos, long id)
	{
		final Note note = this.noteListNoteAdapter.getItem(pos);

		if (note == null)
			return;

		DialogInterface.OnClickListener dialoguePositiveListener = new DialogInterface.OnClickListener()
		{
			public void onClick(DialogInterface dialog, int which)
			{
				deleteNote(note);
			}
		};

		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setMessage(String.format("Are you sure you want to delete \"%s\"?", note.getText()));
		builder.setPositiveButton("Yes", dialoguePositiveListener);
		builder.setNegativeButton("No", null);
		builder.show();
	}

	protected void deleteNote(Note note)
	{
		localRepository.deleteNote(note);

		this.refreshNotes();
	}

	protected void addNotePressed(View v)
	{
		Intent i = new Intent(this, NoteCreate.class);
		this.startActivity(i);
	}

	protected void createAccountPressed(View v)
	{
		Intent i = new Intent(this, Login.class);
		this.startActivity(i);
	}
}

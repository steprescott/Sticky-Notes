package com.aespen.stickynotes;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;

import com.aespen.stickynotes.dao.Note;

public class NoteListNoteAdapter extends android.widget.ArrayAdapter<Note>
{
	public NoteListNoteAdapter(Context context, int resource)
	{
		super(context, resource);
	}

	public View getView(int position, View convertView, ViewGroup parent)
	{
        NoteListRow noteListRow;
		if (convertView == null)
		{
            noteListRow = new NoteListRow(this.getContext());
		}
        else
        {
            noteListRow = (NoteListRow) convertView;
        }

		Note note = this.getItem(position);
        noteListRow.setNoteText(note.getText());
        noteListRow.setNoteDate(note.getCreated());
		return noteListRow;
	}
}
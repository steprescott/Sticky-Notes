package com.aespen.stickynotes;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.aespen.stickynotes.dao.Note;

public class NoteListNoteAdapter extends android.widget.ArrayAdapter<Note>
{
	private LayoutInflater inflater;

	public NoteListNoteAdapter(Context context, int resource)
	{
		super(context, resource);

		inflater = LayoutInflater.from(context);
	}

	public View getView(int position, View convertView, ViewGroup parent)
	{
		if (convertView == null)
		{
			convertView = inflater.inflate(R.layout.note_list_layout, parent, false);
		}

		TextView textView = (TextView) convertView.findViewById(R.id.note_list_item);
		Note note = this.getItem(position);
		textView.setText(note.getText());
		return textView;
	}
}
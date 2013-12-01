package com.aespen.stickynotes;

import android.content.Context;
import android.view.LayoutInflater;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.text.DateFormatSymbols;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class NoteListRow extends RelativeLayout
{
    private TextView noteText;
    private TextView noteDate;
    private TextView noteMonth;
    private TextView noteTime;

    public void setNoteText(String noteText)
    {
        this.noteText.setText(noteText);
    }

    public void setNoteDate(Date noteDate)
    {
        if (noteDate == null)
        {
            return;
        }

        Calendar cal = Calendar.getInstance();
        cal.setTime(noteDate);

        int monthNumber = cal.get(Calendar.MONTH);
        String monthName = this.getMonthNameFromMonthNumber(monthNumber);
        this.noteMonth.setText(monthName.toUpperCase(Locale.getDefault()));

        int date = cal.get(Calendar.DATE);
        this.noteDate.setText(String.valueOf(date));

        int hour = cal.get(Calendar.HOUR);
        int minute = cal.get(Calendar.MINUTE);
        this.noteTime.setText(String.format("%02d:%02d", hour, minute));
    }

    public NoteListRow(Context context)
    {
        super(context);
        
        LayoutInflater.from(context).inflate(R.layout.note_list_layout, this);
        noteText = (TextView) findViewById(R.id.note_list_item_text);
        noteDate = (TextView) findViewById(R.id.note_list_item_date);
        noteMonth = (TextView) findViewById(R.id.note_list_item_month);
        noteTime = (TextView) findViewById(R.id.note_list_item_time);
    }

    private String getMonthNameFromMonthNumber(int month)
    {
        return new DateFormatSymbols().getShortMonths()[month];
    }
}

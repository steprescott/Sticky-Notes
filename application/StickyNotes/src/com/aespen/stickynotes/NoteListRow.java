package com.aespen.stickynotes;

import android.content.Context;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.util.Log;
import android.view.LayoutInflater;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.io.IOException;
import java.text.DateFormatSymbols;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class NoteListRow extends RelativeLayout
{
    private TextView noteText;
    private TextView noteDate;
    private TextView noteMonth;
    private TextView noteTime;
    private TextView noteLocation;
    private Geocoder geoCoder;

    public void setNoteText(String noteText)
    {
        this.noteText.setText(noteText);
    }

    public void setNoteLocation(Double longitude, Double latitude)
    {
        if (longitude == null || latitude == null)
            return;

        try
        {
            List<Address> addressList = this.geoCoder.getFromLocation(longitude, latitude, 1);
            if (addressList == null || addressList.size() != 1)
                return;

            this.noteLocation.setText(addressList.get(0).toString());
        }
        catch (IOException e)
        {

        }
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
        this.noteText = (TextView) findViewById(R.id.note_list_item_text);
        this.noteDate = (TextView) findViewById(R.id.note_list_item_date);
        this.noteMonth = (TextView) findViewById(R.id.note_list_item_month);
        this.noteTime = (TextView) findViewById(R.id.note_list_item_time);
        this.noteLocation = (TextView) findViewById(R.id.note_list_item_location);
        this.geoCoder = new Geocoder(context, Locale.getDefault());
    }

    private String getMonthNameFromMonthNumber(int month)
    {
        return new DateFormatSymbols().getShortMonths()[month];
    }
}

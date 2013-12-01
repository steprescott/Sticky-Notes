package com.aespen.stickynotes;

import com.aespen.stickynotes.core.ServiceLocator;
import com.aespen.stickynotes.dao.Note;
import com.aespen.stickynotes.persistence.ILocalRepository;

import android.app.Activity;
import android.location.Location;
import android.location.LocationManager;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import java.util.Date;

public class NoteCreate extends Activity {
    Location lastKnownLocation;
    LocationManager locationManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_notecreate);

        locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
        lastKnownLocation = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);

        this.initialiseListeners();
    }

    protected void onResume()
    {
        super.onResume();

        lastKnownLocation = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
    }
    
    protected void initialiseListeners()
    {
    	Button btn = (Button) findViewById(R.id.createNoteButton);
        btn.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
            	createNotePressed(v);
            }
        });
    }
    
    protected void createNotePressed(View v)
    {
    	ILocalRepository lr = ServiceLocator.getService(ILocalRepository.class);
    	
    	EditText txt = (EditText) findViewById(R.id.noteText);

        Note note = new Note();

        if (lastKnownLocation != null)
        {
            double latitude = lastKnownLocation.getLatitude();
            double longitude = lastKnownLocation.getLongitude();
            note.setLatitude(latitude);
            note.setLongitude(longitude);
        }

        note.setCreated(new Date());
        note.setText(txt.getText().toString());
        lr.saveNote(note);
    	
    	Toast.makeText(getApplicationContext(), "Note created", Toast.LENGTH_SHORT).show();
    	
    	// Pop the activity from the stack
    	// and return to the note list
    	finish();
    }
}
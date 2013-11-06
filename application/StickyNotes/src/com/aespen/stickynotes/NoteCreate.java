package com.aespen.stickynotes;

import com.aespen.stickynotes.core.ServiceLocator;
import com.aespen.stickynotes.persistence.ILocalRepository;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class NoteCreate extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_notecreate);
        
        
        
        this.initialiseListeners();
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
    	lr.createNote(txt.getText().toString());
    	
    	Toast.makeText(getApplicationContext(), "Note created", Toast.LENGTH_SHORT).show();
    	
    	// Pop the activity from the stack
    	// and return to the note list
    	finish();
    }
}
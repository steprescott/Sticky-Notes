package com.aespen.stickynotes;

import android.app.Activity;
import android.os.Bundle;

public class NoteCreate extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_notecreate);
        
        this.initialiseListeners();
    }
    
    protected void initialiseListeners()
    {

    }
}
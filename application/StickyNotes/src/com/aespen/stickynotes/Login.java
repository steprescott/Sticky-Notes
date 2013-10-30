package com.aespen.stickynotes;

import android.os.Bundle;
import android.app.Activity;
import android.app.AlertDialog;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

public class Login extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        
        Button btn = (Button) findViewById(R.id.continueLogin);
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                continueLoginMethod(v);
            }
        });
    }
    
    public void continueLoginMethod(View v) {
		EditText editTextEmail = (EditText) findViewById(R.id.editTextEmail);
		EditText editTextPassword = (EditText) findViewById(R.id.editTextPassword);

		AlertDialog.Builder altDialog= new AlertDialog.Builder(this);
		altDialog.setMessage(editTextEmail.getText().toString() + editTextPassword.getText().toString());
		altDialog.show();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.landing, menu);
        return true;
    }
}

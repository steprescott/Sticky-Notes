package com.aespen.stickynotes;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import com.aespen.stickynotes.web.WebConnectionDelegate;

import android.os.AsyncTask;
import android.os.Bundle;
import android.accounts.NetworkErrorException;
import android.app.Activity;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class Login extends Activity {

	private WebConnectionDelegate connectionDelegate;
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        
        connectionDelegate = new WebConnectionDelegate();
        
        Button btn = (Button) findViewById(R.id.continueLogin);
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                continueLoginMethod(v);
            }
        });
    }
    
    public void continueLoginMethod(View v) {
		final EditText editTextEmail = (EditText) findViewById(R.id.editTextEmail);
		final EditText editTextPassword = (EditText) findViewById(R.id.editTextPassword);

		new AsyncTask<Void, Void, String>() {

			@Override
			protected String doInBackground(Void... params) {
				try {
					Map <String,String> parameters =  new HashMap<String,String>();
					parameters.put("username", editTextEmail.getText().toString());
					parameters.put("password", editTextPassword.getText().toString());
					
					JSONObject jsonObject = (JSONObject) connectionDelegate.postJsonAtPath("api/login", parameters);
					
					return jsonObject.toString();
//					return jsonObject.optString("user");
				} catch (NetworkErrorException e) {
					Log.v("Error",e.toString());
//					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				} catch (JSONException e) {
					e.printStackTrace();
				}
				return null;
			}
		
			protected void onPostExecute(String result) {
				if (result != null) {
					Toast.makeText(Login.this, "POST : " + result, Toast.LENGTH_SHORT).show();
				}
			};
			
			
		}.execute();
	}
//		AlertDialog.Builder altDialog= new AlertDialog.Builder(this);
//		altDialog.setMessage(editTextEmail.getText().toString() + editTextPassword.getText().toString());
//		altDialog.show();
//    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.landing, menu);
        return true;
    }
}

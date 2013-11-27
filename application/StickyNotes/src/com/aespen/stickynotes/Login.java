package com.aespen.stickynotes;

import java.io.IOException;
import org.json.JSONException;
import org.json.JSONObject;

import com.aespen.stickynotes.dao.ICallbackListner;
import com.aespen.stickynotes.dao.User;
import com.aespen.stickynotes.web.WebConnectionDelegate;

import android.os.Bundle;
import android.accounts.NetworkErrorException;
import android.app.Activity;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

public class Login extends Activity implements ICallbackListner {

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
		try
		{
			connectionDelegate.listner = this;
			
			connectionDelegate.login(editTextEmail.getText().toString(), editTextPassword.getText().toString());
		} catch (NetworkErrorException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JSONException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
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
    
    @Override
    public void callback(JSONObject object)
    {
    	JSONObject userJSON = object.optJSONObject("user");
		
		User newUser = new User();
		newUser.setFirstName(userJSON.optString("firstName"));
		newUser.setSurname(userJSON.optString("surname"));
		newUser.setEmail(userJSON.optString("email"));
		newUser.setId(userJSON.optLong("id"));
		
		Log.e("User details : ", "User " + newUser.toString());
    }
}

package 	com.aespen.stickynotes;

import com.aespen.stickynotes.core.ServiceLocator;
import com.aespen.stickynotes.persistence.LocalRepository;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class NoteList extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_notelist);
        
        this.initialiseListeners();
    }
    
    protected void initialiseListeners()
    {
        Button btn = (Button) findViewById(R.id.addNote);
        btn.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
            	addNotePressed(v);
            }
        });
    }
    
    protected void addNotePressed(View v)
    {
    	Intent i = new Intent(this, NoteCreate.class);
        startActivity(i);
        
        LocalRepository lr = ServiceLocator.GetService(LocalRepository.class);
        
        if (lr != null)
        {
        	new AlertDialog.Builder(this).setMessage(lr.SayHello()).show();
        }
    }
}

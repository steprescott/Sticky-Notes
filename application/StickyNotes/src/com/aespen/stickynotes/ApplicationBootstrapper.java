package com.aespen.stickynotes;

import com.aespen.stickynotes.core.ServiceLocator;
import com.aespen.stickynotes.persistence.LocalRepository;
import com.aespen.stickynotes.persistence.DatabaseHandler;

import android.app.Application;
import android.content.res.Configuration;

public class ApplicationBootstrapper extends Application
{
	private LocalRepository localRepository;
	private DatabaseHandler databaseHandler;

	@Override
	public void onConfigurationChanged(Configuration newConfig)
	{
		super.onConfigurationChanged(newConfig);
	}
	 
	@Override
	public void onCreate()
	{
		super.onCreate();
		
		// Create all global services (our local repository, online repository etc)
		this.createServices();
		
		try
		{
			// Register instances of services with the service locator
			this.registerServices();
		}
		catch (Exception e)
		{
			// Not sure what we'd do here - would mean onCreate was
			// called twice in a session.
			e.printStackTrace();
		}
	}
	 
	@Override
	public void onLowMemory()
	{
		super.onLowMemory();
	}
	 
	@Override
	public void onTerminate()
	{
		super.onTerminate();
	}
	
	private void createServices()
	{
		this.databaseHandler = new DatabaseHandler(getApplicationContext(), "stickyDatabase", null, 1);
		this.localRepository = new LocalRepository();
	}
	
	private void registerServices() throws Exception
	{
		ServiceLocator.<DatabaseHandler>registerService(this.databaseHandler);
		ServiceLocator.<LocalRepository>registerService(this.localRepository);
	}
}

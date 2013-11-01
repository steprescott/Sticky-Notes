package com.aespen.stickynotes;

import com.aespen.stickynotes.core.ServiceLocator;
import com.aespen.stickynotes.persistence.ILocalRepository;
import com.aespen.stickynotes.persistence.LocalRepository;

import android.app.Application;
import android.content.res.Configuration;

public class ApplicationBootstrapper extends Application
{
	private LocalRepository localRepository;

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
		this.localRepository = new LocalRepository(getApplicationContext(), "stickynotes");
	}
	
	private void registerServices() throws Exception
	{
		ServiceLocator.registerService(ILocalRepository.class, this.localRepository);
	}
}

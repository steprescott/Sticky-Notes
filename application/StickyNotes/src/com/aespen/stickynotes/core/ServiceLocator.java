package com.aespen.stickynotes.core;

import java.util.HashMap;

public class ServiceLocator
{
	private static HashMap<Class<?>, Object> instances = new HashMap<Class<?>, Object>();
	
	public static <T> void registerService(Object instance) throws Exception
	{
		Class<? extends Object> type = instance.getClass();
		if (getService(type) == null)
		{
			instances.put(instance.getClass(), instance);
		}
		else
		{
			throw new Exception(String.format("Instance of Class \"%s\" already exists in Service Locator!", instance.getClass()));
		}
	}
	
	public static <T> T getService(Class<T> type)
	{
		Object instance = instances.get(type);
		if (type.isInstance(instance))
		{
			return type.cast(instance);
		}
		else
		{
			return null;
		}
	}
}
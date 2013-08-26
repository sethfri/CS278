package com.example.sodacloudsmsexampleclient;

import java.util.Map;
import java.util.Hashtable;

public class ModuleImpl implements Module {
	
	private Map<Class<?>, Object> classMap = new Hashtable<Class<?>, Object>();

	@Override
	public <T> T getComponent(Class<T> type) {
		return (T)this.classMap.get(type);
	}

	@Override
	public <T> void setComponent(Class<T> type, T component) {
		this.classMap.put(type, component);
	}

}

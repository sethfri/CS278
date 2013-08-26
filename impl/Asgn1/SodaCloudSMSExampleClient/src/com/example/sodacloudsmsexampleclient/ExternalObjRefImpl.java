package com.example.sodacloudsmsexampleclient;

import org.magnum.soda.proxy.ObjRef;

public class ExternalObjRefImpl implements ExternalObjRef {
	
	private ObjRef objRef_;
	private String pubSubHost_;
	
	public ExternalObjRefImpl(ObjRef objRef, String pubSubHost) {
		this.objRef_ = objRef;
		this.pubSubHost_ = pubSubHost;
	}

	@Override
	public ObjRef getObjRef() {
		return this.objRef_;
	}

	@Override
	public String getPubSubHost() {
		return this.pubSubHost_;
	}
	
	@Override
	public String toString() {
		return this.getPubSubHost() + "|" + this.getObjRef().getUri();
	}

}

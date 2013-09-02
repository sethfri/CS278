package org.cs27x.dropbox.test;

import org.cs27x.dropbox.Dropbox;
import org.cs27x.dropbox.HazelcastTransport;
import org.cs27x.dropbox.DropboxProtocol;
import org.cs27x.filewatcher.DropboxFileEventHandler;
import org.cs27x.filewatcher.FileReactor;

import java.nio.file.Path;
import java.nio.file.Paths;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

import static org.mockito.Mockito.*;

public class DropboxTest {
	
	private HazelcastTransport transport;
	private FileReactor reactor;
	
	private Dropbox dropbox;

	@Before
	public void setUp() throws Exception {
		this.transport = mock(HazelcastTransport.class);
		this.reactor = mock(FileReactor.class);
		
		Path rootPath = Paths.get("C:\\Users\\Seth Friedman\\Desktop\\Developer\\CS278\\impl\\Asgn2\\test");
		this.dropbox = new Dropbox(rootPath);
	}

	@Test
	public void testDropbox() {
		verify(this.reactor).addHandler(any(DropboxFileEventHandler.class));
	}

	@Test
	public void testConnect() throws Exception {
		String testServer = "testServer";
		
		this.dropbox.connect(testServer);
		
		verify(this.transport).connect(eq(testServer));
		verify(this.reactor).start();
	}

	@Test
	public void testConnected() {
		this.dropbox.connected();
		
		verify(this.transport).isConnected();
	}

	@Test
	public void testDisconnect() {
		this.dropbox.disconnect();
		
		verify(this.reactor).stop();
		verify(this.transport).disconnect();
	}

	@Test
	public void testAwaitConnect() throws InterruptedException {
		long timeout = 3000;
		
		this.dropbox.awaitConnect(timeout);
		
		verify(this.transport).awaitConnect(eq(timeout));
	}
}

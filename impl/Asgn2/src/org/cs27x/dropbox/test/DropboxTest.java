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
	private DropboxProtocol protocol;
	private FileReactor reactor;
	
	private Dropbox dropbox;

	@Before
	public void setUp() throws Exception {
		this.transport = mock(HazelcastTransport.class);
		this.protocol = mock(DropboxProtocol.class);
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
		
		verify(this.transport).connect(testServer);
		verify(this.reactor).start();
	}

	@Test
	public void testConnected() {
		this.dropbox.connected();
		
		verify(this.transport).isConnected();
	}

	@Test
	public void testDisconnect() {
		fail("Not yet implemented");
	}

	@Test
	public void testAwaitConnect() {
		fail("Not yet implemented");
	}

	@Test
	public void testMain() {
		fail("Not yet implemented");
	}

}

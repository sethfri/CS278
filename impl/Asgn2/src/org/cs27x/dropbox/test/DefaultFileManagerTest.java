package org.cs27x.dropbox.test;

import org.cs27x.dropbox.DefaultFileManager;

import java.nio.file.Path;
import java.nio.file.Paths;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

public class DefaultFileManagerTest {
	
	private Path watchedPath;
	private DefaultFileManager defaultFileManager;

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	@Before
	public void setUp() throws Exception {
		this.watchedPath = Paths.get("C:\\Desktop\\Developer\\CS278\\impl\\Asgn2\\test");
		this.defaultFileManager = new DefaultFileManager(this.watchedPath);
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void testPathExistence() {
		assertTrue(this.defaultFileManager.exists(this.watchedPath));
	}

}

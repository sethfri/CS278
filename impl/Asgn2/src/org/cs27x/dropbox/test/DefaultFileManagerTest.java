package org.cs27x.dropbox.test;

import org.apache.commons.io.FileUtils;
import org.cs27x.dropbox.DefaultFileManager;

import java.io.IOException;
import java.io.InputStream;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

public class DefaultFileManagerTest {
	
	private Path watchedPath;
	private Path testFilePath;
	private DefaultFileManager defaultFileManager;

	@Before
	public void setUp() throws Exception {
		this.watchedPath = Paths.get("C:", "Users", "Seth Friedman",
				"Desktop", "Developer", "CS278", "impl", "Asgn2", "test");
		
		this.testFilePath = Paths.get(this.watchedPath.toString(), "writeTest.txt");
		
		if (!Files.exists(this.watchedPath)) {
			new File(this.watchedPath.toString()).mkdir();
		}
		
		this.defaultFileManager = new DefaultFileManager(this.watchedPath);
	}

	@Test
	public void testPathExistence() {
		assertTrue(this.defaultFileManager.exists(this.watchedPath));
		assertFalse(this.defaultFileManager.exists(Paths.get("fakePath")));
	}
	
	@Test
	public void testWrite() throws IOException {
		String stringToWrite = "Hello World";
		this.defaultFileManager.write(this.testFilePath, stringToWrite.getBytes(), true);
		
		// Get the file contents of writeTest.txt, and test if it is equal to the
		// `String` that should have been written into it.
		File testFile = new File(this.testFilePath.toString());
		
		String stringFromFile = FileUtils.readFileToString(testFile);
		
		assertEquals(stringToWrite, stringFromFile);
		
		// Write the test string again without overriding, and then test to make sure that
		// it was not written in again.
		this.defaultFileManager.write(this.testFilePath, stringToWrite.getBytes(), false);
		
		String updatedStringFromFile = FileUtils.readFileToString(testFile);
		
		assertEquals(updatedStringFromFile, stringFromFile);
	}
	
	@Test
	public void testDeletion() throws IOException {
		this.defaultFileManager.delete(this.testFilePath);
		
		assertFalse(this.defaultFileManager.exists(this.testFilePath));
	}
	
	@Test
	public void testResolve() {
		Path resolvedPath = this.defaultFileManager.resolve("writeTest.txt");
		
		assertEquals(resolvedPath, this.testFilePath);
	}
}

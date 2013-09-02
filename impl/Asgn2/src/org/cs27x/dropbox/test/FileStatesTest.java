package org.cs27x.dropbox.test;

import org.cs27x.filewatcher.FileState;
import org.cs27x.filewatcher.FileStates;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import java.io.IOException;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

public class FileStatesTest {
	
	private FileStates fileStates;
	private Path testPath;

	@Before
	public void setUp() throws Exception {
		this.fileStates = new FileStates();
		this.testPath = Paths.get("C:", "Users", "Seth Friedman", "Desktop",
				"Developer", "CS278", "impl", "Asgn2", "test");
	}

	@Test
	public void testGetState() throws IOException {
		this.fileStates.insert(this.testPath);
		
		FileState fileState = this.fileStates.getState(this.testPath);
		
		assertEquals(fileState.getSize(), Files.size(this.testPath));
		assertEquals(fileState.getLastModificationDate(), Files.getLastModifiedTime(this.testPath));
	}

	@Test
	public void testGetOrCreateState() throws IOException {
		// Create state
		FileState fileState = this.fileStates.getOrCreateState(this.testPath);
		
		assertEquals(-1, fileState.getSize());
		assertNull(fileState.getLastModificationDate());
		
		// Get state
		this.fileStates.insert(this.testPath);
		
		fileState = this.fileStates.getOrCreateState(this.testPath);
		
		assertEquals(fileState.getSize(), Files.size(this.testPath));
		assertEquals(fileState.getLastModificationDate(), Files.getLastModifiedTime(this.testPath));
	}

	@Test
	public void testInsert() throws IOException {
		FileState fileState = this.fileStates.insert(this.testPath);
		
		assertEquals(fileState.getSize(), Files.size(this.testPath));
		assertEquals(fileState.getLastModificationDate(), Files.getLastModifiedTime(this.testPath));
	}

}

# This is the main script for running integration tests for the Dropbox application.

JAR_PATH = ../../../../Dropbox.jar
HOST_PATH  = ./host
CLIENT_PATH  = ./client

# This function tests whether files added are propagated to the appropriate places.
function test_add_files {
	echo 'Test file 1' > $HOST_PATH/host.txt
	if [ -e $CLIENT_PATH/host.txt ]
	then
		echo 'PASS: File created on host propagated to client.'
	else
		echo 'FAIL: File created on host did not propagate to client.'
	fi

	rm $HOST_PATH/host.txt $CLIENT_PATH/client.txt

	echo 'Test file 2' > $CLIENT_PATH/client.txt
	if [ -e $HOST_PATH/client.txt ]
	then
		echo 'PASS: File created on client propagated to host.'
	else
		echo 'FAIL: File created on client did not propagate to host.'
	fi
}

# This function tests whether file updates are propagated to the appropriate places.
function test_update_files {
	echo 'Update 1' > $HOST_PATH/update1.txt
	if [ (cat $HOST_PATH/update1.txt) == (cat $CLIENT_PATH/update1.txt) ]
	then
		echo 'PASS: File update on host propagated to client.'
	else
		echo 'FAIL: File update on host did not propagate to client.'
	fi

	echo 'Update 2' > $CLIENT_PATH/update2.txt
	if [ (cat $CLIENT_PATH/update2.txt) == (cat $HOST_PATH/update2.txt) ]
	then
		echo 'PASS: File update on client propagated to host.'
	else
		echo 'FAIL: File update on client did not propagate to host.'
	fi
}

# This function tests whether deleted files are propagated to the appropriate places.
function test_delete_files {
	rm $HOST_PATH/host.txt
	if [ -e $CLIENT_PATH/host.txt ]
	then
		echo 'FAIL: File deleted on host not propagated to client.'
	else
		echo 'PASS: File deleted on host propagated to client.'
	fi

	rm $CLIENT_PATH/client.txt
	if [ -e $HOST_PATH/client.txt ]
	then
		echo 'FAIL: File deleted on client not propagated to host.'
	else
		echo 'PASS: File deleted on client propagated to host.'
	fi
}

# This function cleans up unnecessary files once the tests have completed.
function cleanup {
	rm -rf $HOST_PATH
	rm -rf $CLIENT_PATH
	echo 'Tests completed.'
}

if [ -e $JAR_PATH ]
then
	# Create the files and directories necessary for the integration testing
	echo 'Setting up the environment for integration testing...'
	mkdir $HOST_PATH
	mkdir $CLIENT_PATH

	# Create files to be updated later in the update tests.
	echo 'Update file 1' > $HOST_PATH/update1.txt
	echo 'Update file 1' > $CLIENT_PATH/update1.txt
	
	echo 'Update file 2' > $HOST_PATH/update2.txt
	echo 'Update file 2' > $CLIENT_PATH/update2.txt

	# Start the Dropbox host
	java -jar $JAR_PATH $HOST &> host$OUTPUT &
	sleep 1

	# Start the Dropbox client
	java -jar $JAR_PATH $CLIENT $(ipconfig getifaddr en1) &> client$OUTPUT &
	sleep 1

	test_add_files

	test_update_files

	cleanup
else
	echo 'The file Dropbox.jar does not exist in the Asgn3 directory. Please create this file from the project and try again.'
fi

# This is the main script for running integration tests for the Dropbox application.

JAR_PATH = ../../../../Dropbox.jar
HOST_PATH  = ./host
CLIENT_PATH  = ./client
OUTPUT_PATH = output.txt

# This function tests whether files added are propagated to the appropriate places.
function test_add_files {
	echo 'Test file 1' > $HOST_PATH/host.txt
	if [ -e $CLIENT_PATH/client.txt ]
	then
		echo 'PASS: File created on host propagated to client.'
	else
		echo 'FAIL: File created on host did not propagate to client.'
	fi

	rm $HOST_PATH/host.txt $CLIENT_PATH/client.txt

	echo 'Test file 2' > $CLIENT_PATH/client.txt
	if [ -e $HOST_PATH/host.txt ]
	then
		echo 'PASS: File created on client propagated to host.'
	else
		echo 'FAIL: File created on client did not propagate to host.'
	fi
}

# This function tests whether file updates are propagated to the appropriate places.
function test_update_files {
}

if [ -e $JAR_PATH ]
then
	# Create the files and directories necessary for the integration testing
	echo 'Setting up the environment for integration testing...'
	mkdir $HOST_PATH
	mkdir $CLIENT_PATH
	
	if [ -e $OUTPUT_PATH ]
	then
		rm $OUTPUT_PATH
	fi

	# Start the Dropbox host
	java -jar $JAR_PATH $HOST &> host$OUTPUT &
	sleep 1

	# Start the Dropbox client
	java -jar $JAR_PATH $CLIENT $(ipconfig getifaddr en1) &> client$OUTPUT &
	sleep 1

else
	echo 'The file Dropbox.jar does not exist in the Asgn3 directory. Please create this file from the project and try again.'
fi

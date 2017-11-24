# README

Centraliserd Log system is to provide a debugging platforms to the developers to check the logs data from different servers
For Each log format a different model has to be created and the log files has to be imported to the mysql
Here we have used the access.log file and its format and created a model for it and provided a UI to query the table as per the developers need
Also we have a direct UI to upload files directly to the mysql ( It will insert only the incremental data)
We have implemented a Log Forworder using inotifywait command to check for any new insertions in the concerned file and upload it to the centralised log server using the  same UI upload method
We have Dockerised the Application such that it can be run with mysql in teh same container host , we can start importing the data and work on the quering part.

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version:2.3.1
  Mysql Version:5.6.22

* Configuration : unicron.rb has to be configured to increase the number of workers.

* System dependencies : Docker needs to be installed to run the docker file 

* Database creation : Install mysql in a host and update it in database.yml , create a mysql database with db name 	 logs and password ""(For better security passwords can be set during installation and changed in database.yml)

* Deployment instructions
    * Logs files structure has to be known and the parser can be changed as per the need and can be evolved
      example log file used is uploaded (access.log)
    * We can clone the Directory and start the  server by bundle exec unicorn -p 3000 -c ./config/unicorn.rb 
      to start the server with unicorn configuration 
    * Logs are being pushed under log/application.log, log/unicorn.stout.log and log/unicorn.stderr.log
    * Number of worker count can be increased using worker process in the configuration
    * Docker image can be created by following the below stops as the dockerfile is uploaded as well
        Docker image has both ruby and database setup in a single image, we can import the data and start querying
	    cd log_service/
	    docker build -t log_service:0.1 .
	    docker run -it log_service:0.1 
	    we can enter into the docker container through
	    docker exec -it $container_id /bin/bash  and curl the response and check the logs for more details

* Client Side setup
   In the Client side we need to install inotify-tools to use inotifywait command
   we need to schedule a cronjob which monitors the log file and uploads the data to the centralised log server
   Below are the configuration Details:
	   #!/bin/bash
		while inotifywait -e modify access.log; do
	    	curl -X POST -F 'myfile=@/$file_location/access.log' localhost:3000/centralised_log/upload_logs  
		done
   inotifywait command will push the changes if there is any new insert in the log file 

* API Description
	http://localhost:3000/centralised_log/
		displays options to either query or upload logs

	http://localhost:3000/centralised_log/querying_logs/
	    displays the querying_tab
	    	choose a search phrase
	    	type a sql query based on the columns in the left
	    	click on the sidebar columns to get the maximum five variables of the field

	http://localhost:3000/centralised_log/prompt_to_upload_log/
 		displays the upload page to upload a log file
 		Please use access.log file and upload it

 	Log Forwarder will also be using the same post request to upload the file which is being tracked and imports teh data to the db
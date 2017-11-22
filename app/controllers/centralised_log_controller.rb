class CentralisedLogController < ApplicationController
	skip_before_filter :verify_authenticity_token 
	include CentralisedLogHelper

	def upload_logs
		log_file=(params[:myfile])
		puts log_file.class
		log_file=File.new(params[:myfile])
		puts log_file.class
		csv_file="#{log_file}.csv"
		import_logs_to_csv(log_file,csv_file)
		@status = "File uploaded successfully!"
		redirect_to '/centralised_log/prompt_to_upload_log'
	end

	def prompt_to_upload_log
		if(params[:status].present?)
			@status = params[:status]
		end
	end
end

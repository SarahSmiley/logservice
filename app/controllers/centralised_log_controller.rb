class CentralisedLogController < ApplicationController
	skip_before_filter :verify_authenticity_token 
	include CentralisedLogHelper

	def upload_logs
		log_file=params[:myfile].path
		puts log_file
		import_logs_to_csv(log_file)
		redirect_to '/centralised_log/prompt_to_upload_log' , :notice => "File uploaded successfully!"
	end

	def prompt_to_upload_log
		if(params[:status].present?)
			@status = params[:status]
		end
	end
end
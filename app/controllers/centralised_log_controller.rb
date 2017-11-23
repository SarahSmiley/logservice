class CentralisedLogController < ApplicationController
	skip_before_filter :verify_authenticity_token 
	include CentralisedLogHelper

	def upload_logs
		log_file=params[:myfile].path
		puts log_file
		import_logs_to_csv(log_file)
		@status = "File uploaded Successfully"
		redirect_to '/centralised_log/prompt_to_upload_log'
	end

	def prompt_to_upload_log
	end

	def querying_logs
        @column_names=AccessLog.column_names
        if params[:sql_query].present? 
		@records_array = ActiveRecord::Base.connection.execute(params[:sql_query])
		end
        #column_names.each do |column|
        #distinct_column_data=AccessLog.select(:"#{column}").distinct
        #distinct_column_data.each  do 
        #if params[:search_string].present?
        
	end

end
class CentralisedLogController < ApplicationController
	#skip_before_filter :verfy_authenticity_token 
	require 'date'
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
		total_count = AccessLog.count
        @column_names=AccessLog.column_names
        if params[:sql_query].present? 
			querying_directly_by_sql_query(params[:sql_query])
		end
        if params[:search_string].present?
        	if params[:start_time].nil? || params[:stop_time].nil? 
        		start_time = DateTime.now - 1.day
        		stop_time = DateTime.now
        	else
        		start_time=params[:start_time]
        		stop_time=params[:stop_time]
        	end
 		 	querying_by_search_string(params[:search_string],@column_names,start_time,stop_time)
        end
        if params[:selected_column].present?
        	@selected_column=params[:selected_column]
        	querying_by_selected_column(@selected_column,total_count)
        end
	end
end
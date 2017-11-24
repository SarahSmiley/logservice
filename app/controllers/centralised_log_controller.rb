class CentralisedLogController < ApplicationController
	#skip_before_filter :verfy_authenticity_token 
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
			querying_directly_by_sql_query(params[:sql_query])
		end
        #column_names.each do |column|
        #distinct_column_data=AccessLog.select(:"#{column}").distinct
        #distinct_column_data.each  do 
        #if params[:search_string].present?
        total_count = AccessLog.count
        if params[:selected_column].present?
        	@selected_column=params[:selected_column]
        	querying_by_selected_column(@selected_column,total_count)
        end
        #@records_array = AccessLog.select('count("#{selected_column}") as count,selected_column order by count("#{selected_column}")').group(:selected_column).limit 5
        #select count(ip), ip from access_logs group by ip order by count(ip) desc limit 5;
	end

end
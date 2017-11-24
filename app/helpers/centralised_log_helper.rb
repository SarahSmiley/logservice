module CentralisedLogHelper
	require 'csv'
	def import_logs_to_csv(log_file)
		puts log_file
		File.open("/tmp/temporary_csvfile", "w") do |csv|
			File.open(log_file, "r") do |f|
				f.each_line do |line|
				line = line.gsub(/[()""+-]/, '')
				line = line.delete "[]"
				ip, date, time_range, request_type, url ,protocol, response, extra_code , browser_request , browser_request1, browser_request2 , line = line.split(/\s+/) 
				datetime=DateTime.strptime(date, ' %d/%b/%Y:%H:%M:%S ').to_time
				csv << "#{ip}, #{datetime}, #{request_type}, #{url} , #{protocol}, #{response} , #{browser_request}, #{browser_request1}, #{browser_request2}, #{line} \n"
				end
			end
		end
		File.delete(log_file)
		insert_csv_to_db("/tmp/temporary_csvfile")
	end

	def insert_csv_to_db(csv_file)
		Rails.logger.debug "exporting in db"
		log_file = CSV.open(csv_file)
        log_file.each do |row|
            AccessLog.create!(
                :ip                	=> row[0],
                :datetime         	=> row[1],
                :request_type	    => row[2],
                :url                => row[3],
                :protocol 			=> row[4],
                :response   		=> row[5],
                :request_detail1    => row[6],
                :request_detail2   	=> row[7],
                :request_detail3    => row[8]
            )
        end
        File.delete(csv_file)
	end

	def querying_by_selected_column(selected_column,total_count)
		@percentage_hash={}
    	puts total_count
    	sql_query = "select count(#{selected_column}), #{selected_column} from access_logs group by #{selected_column} order by count(#{selected_column}) desc limit 5;"
    	records_array = ActiveRecord::Base.connection.execute(sql_query)
    	records_array.each do |a| 
    		puts a[0].class
    		puts total_count
    		percentage = (a[0]*100/total_count)
    		puts percentage
    		puts a.class
    		@percentage_hash["#{a[1]}"] = [a[0],percentage]
    	end
    	puts @percentage_hash
	end

	def querying_directly_by_sql_query(sql_query)
		@sql_records_array = ActiveRecord::Base.connection.execute(params[:sql_query])
	end

	def querying_by_search_string(search_string,column_names)
		@data=0
		puts column_names
		@full_data = nil
		column_names.each do |column|
			puts column
			data=AccessLog.where("#{column} like ?",  "%#{search_string}%")
			if @full_data.present?
				@full_data=@full_data.or(data)
			else
				@full_data=data            	
           end
		end
	end
end

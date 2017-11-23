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
end

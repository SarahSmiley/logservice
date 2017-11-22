class ChangeAccessLogDataType < ActiveRecord::Migration[5.0]
  def change
  	change_column :access_logs, :url, :text
  end
end

class CreateAccessLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :access_logs do |t|
      t.string     :ip
      t.datetime   :datetime
      t.string     :request_type
      t.string     :url
      t.string     :protocol
      t.integer    :response
      t.string     :request_detail1
      t.string     :request_detail2
      t.string     :request_detail3
      t.string     :other_details
      t.timestamps
    end
  end
end

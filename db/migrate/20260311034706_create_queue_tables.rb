class CreateQueueTables < ActiveRecord::Migration[8.1]
  def change
    create_table :queue_tables do |t|
      t.timestamps
    end
  end
end

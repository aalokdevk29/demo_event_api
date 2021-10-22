class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :url
      t.string :visitor_id
      t.bigint :timestamp

      t.timestamps
    end
  end
end

class CreateMetroStations < ActiveRecord::Migration[7.0]
  def change
    create_table :metro_stations do |t|
      t.string :node_id
      t.integer :x
      t.integer :y
      t.string :name

      t.timestamps
    end
  end
end

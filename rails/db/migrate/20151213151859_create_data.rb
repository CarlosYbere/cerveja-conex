class CreateData < ActiveRecord::Migration
  def change
    create_table :sensor_data do |t|
      t.float :amp
      t.float :pot
      t.float :kwhmes
      t.float :kwhdia
      t.float :conta

      t.timestamps null: false
    end
  end
end

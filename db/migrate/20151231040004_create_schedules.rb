class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :user_id
      t.date :date

      t.timestamps null: false
    end

    add_index :schedules, :date, unique: true
  end
end

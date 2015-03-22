class CreatePowerForms < ActiveRecord::Migration
  def change
    create_table :power_forms do |t|
      t.string :appliance
      t.datetime :starttime
      t.datetime :endtime

      t.timestamps null: false
    end
  end
end

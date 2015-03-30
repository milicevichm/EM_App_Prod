class CreatePowerForms < ActiveRecord::Migration
  def change
    create_table :power_forms do |t|
      t.string :appliance
      t.datetime :tstart
      t.datetime :tend

      t.timestamps null: false
    end
  end
end

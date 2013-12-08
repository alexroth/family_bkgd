class CreateFamilyStartPoints < ActiveRecord::Migration
  def change
    create_table :family_start_points do |t|
      t.string :family_descrip
      t.integer :membid
      t.text :comment
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end

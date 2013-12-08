class CreateFamilyData < ActiveRecord::Migration
  def change
    create_table :family_data do |t|
      t.string :name
      t.string :gender
      t.integer :membid
      t.string :father
      t.integer :fatherid
      t.string :mother
      t.integer :motherid
      t.date :birth_date
      t.string :birth_place
      t.text :comment
      t.string :hash5
      t.datetime :created_at
      t.datetime :updated_at
      t.string :override_year

      t.timestamps
    end
  end
end

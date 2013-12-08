class CreateFamilyAliases < ActiveRecord::Migration
  def change
    create_table :family_aliases do |t|
      t.string :name
      t.integer :membid
      t.string :type_of_name
      t.string :alias_name
      t.string :alias_hash5
      t.text :comment
      t.datetime :created_at
      t.datetime :updated_at
      t.string :other_type_value

      t.timestamps
    end
  end
end

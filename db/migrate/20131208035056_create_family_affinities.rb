class CreateFamilyAffinities < ActiveRecord::Migration
  def change
    create_table :family_affinities do |t|
      t.string :name
      t.integer :membid
      t.string :relationship
      t.string :other_type_value
      t.string :connection_name
      t.integer :connection_membid
      t.text :comment
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end

class CreateFamilyDocuments < ActiveRecord::Migration
  def change
    create_table :family_documents do |t|
      t.string :doc_descrip
      t.string :doc_type
      t.string :doc_link
      t.string :name
      t.integer :membid
      t.text :comment
      t.datetime :created_at
      t.datetime :updated_at
      t.string :event_type
      t.date :event_date
      t.string :event_place
      t.string :place_type
      t.string :other_doc_type
      t.string :other_place_type
      t.string :other_event_type

      t.timestamps
    end
  end
end

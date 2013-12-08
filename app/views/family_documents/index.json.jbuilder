json.array!(@family_documents) do |family_document|
  json.extract! family_document, :id, :doc_descrip, :doc_type, :doc_link, :name, :membid, :comment, :created_at, :updated_at, :event_type, :event_date, :event_place, :place_type, :other_doc_type, :other_place_type, :other_event_type
  json.url family_document_url(family_document, format: :json)
end

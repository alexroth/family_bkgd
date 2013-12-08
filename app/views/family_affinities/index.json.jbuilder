json.array!(@family_affinities) do |family_affinity|
  json.extract! family_affinity, :id, :name, :membid, :relationship, :other_type_value, :connection_name, :connection_membid, :comment, :created_at, :updated_at
  json.url family_affinity_url(family_affinity, format: :json)
end

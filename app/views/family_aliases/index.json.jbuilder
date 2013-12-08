json.array!(@family_aliases) do |family_alias|
  json.extract! family_alias, :id, :name, :membid, :type_of_name, :alias_name, :alias_hash5, :comment, :created_at, :updated_at, :other_type_value
  json.url family_alias_url(family_alias, format: :json)
end

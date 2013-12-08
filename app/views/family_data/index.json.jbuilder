json.array!(@family_data) do |family_datum|
  json.extract! family_datum, :id, :name, :gender, :membid, :father, :fatherid, :mother, :motherid, :birth_date, :birth_place, :comment, :hash5, :created_at, :updated_at, :override_year
  json.url family_datum_url(family_datum, format: :json)
end

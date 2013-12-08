json.array!(@family_start_points) do |family_start_point|
  json.extract! family_start_point, :id, :family_descrip, :membid, :comment, :created_at, :updated_at
  json.url family_start_point_url(family_start_point, format: :json)
end

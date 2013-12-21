json.array!(@places) do |place|
  json.extract! place, :id, :location
#  json.url place_url(place, format: :json)
end

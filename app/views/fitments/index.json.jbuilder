json.array!(@fitments) do |fitment|
  json.extract! fitment, :id, :make, :year, :model, :engine
  json.url fitment_url(fitment, format: :json)
end

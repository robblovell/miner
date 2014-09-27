json.array!(@capstones) do |capstone|
  json.extract! capstone, :id, :index, :number
  json.url capstone_url(capstone, format: :json)
end

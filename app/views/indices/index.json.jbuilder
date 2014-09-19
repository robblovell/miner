json.array!(@indices) do |index|
  json.extract! index, :id, :miner, :mode, :make, :year, :model, :engine, :system, :dtc
  json.url index_url(index, format: :json)
end

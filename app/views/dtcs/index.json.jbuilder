json.array!(@dtcs) do |dtc|
  json.extract! dtc, :id, :code, :description, :meaning, :source
  json.url dtc_url(dtc, format: :json)
end

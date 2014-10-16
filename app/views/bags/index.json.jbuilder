json.array!(@bags) do |bag|
  json.extract! bag, :id, :sheet, :type
  json.url bag_url(bag, format: :json)
end

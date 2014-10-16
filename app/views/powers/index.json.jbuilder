json.array!(@powers) do |power|
  json.extract! power, :id, :parent_id, :name, :url, :remark
  json.url power_url(power, format: :json)
end

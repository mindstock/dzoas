json.array!(@employees) do |employee|
  json.extract! employee, :id, :name, :phone, :address, :department
  json.url employee_url(employee, format: :json)
end

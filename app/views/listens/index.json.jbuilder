json.array!(@listens) do |listen|
  json.extract! listen, :id, :plan_type, :first_status, :last_status
  json.url listen_url(listen, format: :json)
end

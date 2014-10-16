json.array!(@messages) do |message|
  json.extract! message, :id, :title, :content, :complete_at, :remark, :type, :status
  json.url message_url(message, format: :json)
end

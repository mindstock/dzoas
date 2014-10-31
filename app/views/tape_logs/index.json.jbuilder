json.array!(@tape_logs) do |tape_log|
  json.extract! tape_log, :id, :type, :num, :finish_at
  json.url tape_log_url(tape_log, format: :json)
end

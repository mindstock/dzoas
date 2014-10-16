json.array!(@quclity_checks) do |quclity_check|
  json.extract! quclity_check, :id, :is_standard, :remark
  json.url quclity_check_url(quclity_check, format: :json)
end

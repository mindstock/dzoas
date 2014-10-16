json.array!(@nickelclads) do |nickelclad|
  json.extract! nickelclad, :id, :thickness, :wide, :length, :to, :allowance, :is_declicacy
  json.url nickelclad_url(nickelclad, format: :json)
end

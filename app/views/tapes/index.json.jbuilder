json.array!(@tapes) do |tape|
  json.extract! tape, :id, :from, :place, :texture, :thickness, :wide, :length, :raw_weight, :put_weight, :out_weight, :residue_weight, :tape_num
  json.url tape_url(tape, format: :json)
end

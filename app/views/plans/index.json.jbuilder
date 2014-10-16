json.array!(@plans) do |plan|
  json.extract! plan, :id, :thickness, :wide, :length, :final_sheet, :final_piece, :final_row, :finish_at, :real_finish_at, :is_urgency, :allowance, :is_declicacy, :to, :status
  json.url plan_url(plan, format: :json)
end

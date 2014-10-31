module BagsHelper

	def get_sheet_by_nickelclad nickelclad_id
		Bag.where(nickelclad_id: nickelclad_id).count
	end
	def bat_sheet nickelclad_id
		Bag.where(nickelclad_id: nickelclad_id, is_nickelclad_top: 0).sum("sheet").to_i
	end

	def bag_creat sheet, is_nickelclad_top, nickelclad_id
		bag = Bag.new
		bag.sheet = sheet
		bag.is_nickelclad_top = is_nickelclad_top
		bag.nickelclad_id = nickelclad_id
      	bag.save
	end

	def sheet_split params
		tmp = params[:sheet]

		tmp.split('+').each do |sheet|
			if sheet.include?('*')
				_sheet = sheet.split("*")
				_sheet[1].to_i.times do |i|
					bag_creat(_sheet[0], 0, params[:nickelclad_id])
				end
			elsif sheet.include?('.')
				bag_creat(sheet, 1, params[:nickelclad_id])
			else
				bag_creat(sheet, 0, params[:nickelclad_id])
			end
		end
		
	end
end

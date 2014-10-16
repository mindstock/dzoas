module BagsHelper

	def get_sheet_by_nickelclad nickelclad_id
		Bag.where(nickelclad_id: nickelclad_id).count
	end
end

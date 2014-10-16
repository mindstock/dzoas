module NickelcladsHelper
	def nickelclad_update id, field, value
		nickelclad = Nickelclad.find_by(id: id)
		_hash = {field => value}
		nickelclad.update(_hash)
	end
	def nickelclad_update_by_hash id, params
		nickelclad = Nickelclad.find_by(id: id)
		nickelclad.update(params)
	end
end

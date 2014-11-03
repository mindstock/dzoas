module RolesHelper
	#删除对应菜单
	def del_power role_id
		sql = "delete from roles_powers where role_id = #{role_id}"
		Role.connection.execute sql
	end

	#新增对应菜单
	def add_power role_id, power_ids
		power_ids.each do |power|
			sql = "insert into roles_powers (role_id, power_id) values(#{role_id}, #{power});"
			Role.connection.execute sql
		end
	end

	def get_power_ids_by_role_id role_id
		sql = "select power_id from roles_powers where role_id = #{role_id}"
		power_ids = []
		puts Role.connection.execute(sql).to_a
		Role.connection.execute(sql).to_a.each do |id|
			power_ids << id[0]
		end
		power_ids
	end

end

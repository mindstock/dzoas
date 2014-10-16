module EmployeesHelper
	def sys_user_del user_id
		User.connection.execute("delete from users where id = #{user_id}");
		
	end
end

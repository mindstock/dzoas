module ListensHelper

	#新建对象
	def new_listen  type, first, last
		listen = Listen.new
		listen.plan_type = type
		listen.first_status = first
		listen.last_status = last
		listen
	end

	#新增监听
	def add_listen type, first, last
		listen = new_listen type, first, last
		listen.save
	end

	def update_listen id, params
		listen = Listen.find(id)
		listen.update params
	end
end

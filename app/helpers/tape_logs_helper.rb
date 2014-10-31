module TapeLogsHelper
	#type 0:出库
	def log_create num, tape_id, type=0
		time = Time.now.strftime("%Y-%m-%d %H:%M")
		tape_log = TapeLog.new
		tape_log.num = num
		tape_log.tape_id = tape_id
		tape_log.exec_type = type
		tape_log.finish_at = time
		tape_log.save
		
	end
end

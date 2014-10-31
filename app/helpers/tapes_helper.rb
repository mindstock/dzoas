require 'spreadsheet'

module TapesHelper
	# File_root = '/js/sydz/dzoas/tapes.xls'
	File_root = '/home/wwwroot/dzoas/public/upload/public_file'
	Excel_name = File_root + "/tapes.xls"

	def mkdirs(path)
	    if(!File.directory?(path))
	        if(!mkdirs(File.dirname(path)))
	            return false;
	        end
	        Dir.mkdir(path)
	    end
	    return true
  	end

  	def get_list page, type
  		tapes = case type
  		when 'day'
  			time = Time.now.strftime("%Y-%m-%d")
  			sql = "select DISTINCT tape_id from tape_logs where finish_at like '%#{time}%'"
  			Tape.where(id: get_tape_ids(sql)).page(page)
  		when 'month'
  			time = Time.now.strftime("%Y-%m")
  			sql = "select DISTINCT tape_id from tape_logs where finish_at like '%#{time}%'"
  			Tape.where(id: get_tape_ids(sql)).page(page)
  		when 'year'
  			time = Time.now.strftime("%Y")
  			sql = "select DISTINCT tape_id from tape_logs where finish_at like '%#{time}%'"
  			Tape.where(id: get_tape_ids(sql)).page(page)
  		else
  			Tape.where("status != 2").page(page)
  		end
  	end

  	def get_tape_ids sql
  		ids = []
		  TapeLog.connection.execute(sql).to_a.each do |id|
			 ids << id[0]
		  end
		  ids
  	end

  	def get_out_weight type, start_at = nil, end_at = nil
  		weight = case type
  		when 'day'
  			time = Time.now.strftime("%Y-%m-%d")
  			TapeLog.connection.execute("select sum(num),count(id) from tape_logs where exec_type = 0 and finish_at like '%#{time}%'").to_a[0]
  		when 'month'
  			time = Time.now.strftime("%Y-%m")
  			TapeLog.connection.execute("select sum(num),count(id) from tape_logs where exec_type = 0 and finish_at like '%#{time}%'").to_a[0]
  		when 'year'
  			time = Time.now.strftime("%Y")
  			TapeLog.connection.execute("select sum(num),count(id) from tape_logs where exec_type = 0 and finish_at like '%#{time}%'").to_a[0]
  		else
  			# TapeLog.where("exec_type = 0 and finish_at >= #{start_at} and finish_at <= #{end_at}").sum('num')
  		end
  	end

  	#钢卷出库
  	#出库时 plan状态为5
  	def tape_out plan
  		tape, nickelclad = plan.tape, plan.nickelclad
  		tape_id, plan_merge = tape.id, plan.tape_merge
  		#剩余数量  出库数量
  		_resdue_weight, _out_weight = tape.residue_weight.to_i, tape.out_weight.to_i
  		resdue_weight, out_weight = 0, 0
  		weight = 0
  		if tape.status == 1    #收卷
  			plans = Plan.where(tape_id: tape_id, tape_merge: plan_merge)
  			weight = get_tape_weight_by_plans(plans)
  			out_weight = _out_weight + weight
  			residue_weight = _resdue_weight - weight
  		else
  			weight = _resdue_weight
  			out_weight = _out_weight + weight
  			residue_weight = 0
  		end 
      profit = get_profit(tape) - tape.raw_weight
  		tape_update_by_hash tape_id, {profit: profit, out_weight: out_weight, residue_weight: residue_weight, out_at: Time.now.strftime("%Y-%m-%d %H:%M")}
  		weight
  	end

    #得到钢卷盈利情况
    # <%= (nickelclad.thickness.to_f * (nickelclad.wide.to_f / 1000) * (nickelclad.length.to_f / 1000) * 7.85 * nickelclad.real_final_sheet.to_i - (tape.out_weight.to_i - tape.residue_weight.to_i)).to_i %>
    def get_profit tape
      _weight = 0
      tape.plan.each do |plan|
        nickelclad = plan.nickelclad
        _weight += get_weight(nickelclad.real_final_sheet, nickelclad.length, nickelclad.wide, nickelclad.thickness)
      end
      _weight
    end

  	def get_weight sheet, length, wide, thickness
  		(sheet.to_i * 7.85 * (length.to_f / 1000) * (wide.to_f / 1000) * thickness.to_f).to_i
  	end

  	def get_tape_weight_by_plans plans
  		_out_weight = 0
  		#real_final_sheet * 7.85 * (nickelclad.length.to_f / 1000) * (nickelclad.wide.to_f / 1000) * nickelclad.thickness.to_f)
		puts plans.length
  		plans.each do |plan|
  			nickelclad = plan.nickelclad
  			_out_weight += get_weight nickelclad.real_final_sheet, nickelclad.length, nickelclad.wide, nickelclad.thickness

  			#判断是否有板头
  			bags = Bag.where(nickelclad_id: nickelclad.id, is_nickelclad_top: 1)
  			if bags.length > 0
  				bags.each do |bag|
  					_out_weight += get_weight 1, (bag.sheet.to_f * 1000), nickelclad.wide, nickelclad.thickness
  				end
  			end
  		end
  		_out_weight
  	end

	def get_tapes_by_ids ids
		tapes = []
		ids.each do |id|
			tapes << Tape.find_by(id: id)
		end
		tapes
	end

	def tape_update id, field, value
		tape = Tape.find_by(id: id)
		_hash = {field => value}
		tape.update(_hash)
	end

	def tape_update_by_hash id, params
		tape = Tape.find_by(id: id)
		tape.update(params)
	end

	#根据条件查找tapes
	def tapes_search params, add_where = nil
		where = params.permit(:from, :place, :texture, :size, :status, :tape_num).delete_if{|key,value| value.empty?}
		where = where.merge(add_where) if add_where != nil
		unless params[:size].empty?
			size = params[:size].split("*")
			where = where.merge(thickness: size[0], wide: size[1]).delete_if{|key,value| key=='size'}
		end
    	Tape.where(where).page(params[:page])
	end

	#上传文件
	def ex_upload(file_field)
		mkdirs File_root unless Dir.exists? File_root
        File.open(Excel_name, "wb+") do |f|
            f.write(file_field.read)
        end
    end

    #根据钢卷号判断是否存在
    def tape_num_exist? value
    	Tape.find_by(tape_num: value)
    end

    #读取文件
    def read_file
    	Spreadsheet.client_encoding = "UTF-8" 
		book = Spreadsheet.open Excel_name
		i = 0
		book.worksheets.each do |sheet|
		  sheet.each 3 do |row|
		  	from = row[0].to_s
		  	# next if from.empty?
		  	tape_num = row[15].to_s.gsub(/\.0/,"")
		  	next if tape_num.to_s.empty? or tape_num_exist?(tape_num)
		    tape = Tape.new
			tape.from = row[0]
			tape.place = row[12]
			tape.texture = row[2]
			size = row[3].to_s.split('*')
			tape.thickness = size[0]
			tape.wide = size[1]
			tape.length = size[2]
			tape.raw_weight = row[5]
			tape.put_weight = row[7]
			tape.out_weight = row[9]
			tape.residue_weight = row[11].value
			if tape.residue_weight.to_i <= 0
				tape.status = 2			#用完
			else 
				tape.status = 0			#新卷
			end
			tape.tape_num = tape_num
			tape.save
		  end
		end
	end
end

# encoding: utf-8
require 'spreadsheet'

module TapesHelper
	# File_root = '/Users/mindstock/Documents/code/ruby/sydz/dzoas/public'
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

    def get_all_weight
      TapeLog.connection.execute("select sum(residue_weight),count(id) from tapes where status in(0, 1, 3)").to_a[0]
    end

  	#钢卷出库
  	#出库时 plan状态为5
  	def tape_out plan
  		tape, nickelclad = plan.tape, plan.nickelclad
  		tape_id, plan_merge = tape.id, plan.tape_merge
  		#剩余数量  出库数量
  		_resdue_weight, _out_weight = tape.residue_weight.to_i, tape.out_weight.to_i
  		resdue_weight, out_weight = 0, 0
  		weight, profit = 0, nil
  		if tape.status == 1    #收卷
  			plans = Plan.where(tape_id: tape_id, tape_merge: plan_merge)
  			weight = get_tape_weight_by_plans(plans)
  			out_weight = _out_weight + weight
  			residue_weight = _resdue_weight - weight
  		else
  			weight = _resdue_weight
  			out_weight = _out_weight + weight
  			residue_weight = 0
        profit = get_profit(tape) - tape.raw_weight.to_i
  		end 
  		tape_update_by_hash tape_id, {profit: profit, out_weight: out_weight, residue_weight: residue_weight, out_at: Time.now.strftime("%Y-%m-%d %H:%M")}
  		weight
  	end

    #得到钢卷盈利情况
    # <%= (nickelclad.thickness.to_f * (nickelclad.wide.to_f / 1000) * (nickelclad.length.to_f / 1000) * 7.85 * nickelclad.real_final_sheet.to_i - (tape.out_weight.to_i - tape.residue_weight.to_i)).to_i %>
    def get_profit tape
      _weight = 0
      tape.plan.each do |plan|
        nickelclad = plan.nickelclad
        _weight += get_weight(nickelclad.real_final_sheet, nickelclad.length, nickelclad.wide, tape.thickness)
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

    def read_head row, index
      head = {}
      row.each_with_index do |row, index|
        # puts row
        case row
        when "供应商"
          head["from"] = index
        when "存放地", "单位"
          head["local"] = index
        when "材质"
          head["texture"] = index
        when "规格"
          head["size"] = index
        when "单价"
          head["单价"] = index
        when "期初数量"
          head["raw_weight"] = index
        when "期初金额"
          head["期初金额"] = index
        when "入库数量"
          head["put_weight"] = index
        when "入库金额"
          head["入库金额"] = index
        when "出库数量"
          head["out_weight"] = index
        when "出库金额"
          head["出库金额"] = index
        when "结存数量"
          head["residue_weight"] = index
        when "库位"
          head["place"] = index
        when "盘存数量"
          head["盘存数量"] = index
        when "结存金额"
          head["结存金额"] = index
        when "钢卷号"
          head["tape_num"] = index
        end
      end
      head
    end


    #读取文件
    def read_file
    	Spreadsheet.client_encoding = "UTF-8" 
		book = Spreadsheet.open Excel_name
		i = 0
		book.worksheets.each do |sheet|
      head = {}
		  sheet.each_with_index 2 do |row, index|
        if index == 0
          head = read_head(row, index)
        else
          tape_num = row[head["tape_num"]].to_s.gsub(/\.0/,"")
          next if tape_num.empty? or tape_num_exist?(tape_num) or row[head["texture"]].to_s.empty?
          tape = Tape.new
          tape.from = row[head["from"]]
          tape.place = row[head["place"]]  if head["place"]
          tape.texture = row[head["texture"]]
          size = row[head["size"]].to_s.split('*')
          tape.thickness = size[0]
          tape.wide = size[1]
          tape.length = size[2]
          tape.raw_weight = row[head["raw_weight"]]
          tape.put_weight = row[head["put_weight"]]
          tape.out_weight = row[head["out_weight"]]
          tape.residue_weight = row[head["residue_weight"]].value
          if tape.residue_weight.to_i <= 0
            tape.status = 2     #用完
          elsif tape.out_weight.to_i > 0 and tape.residue_weight.to_i > 0
            tape.status = 1     #收卷
          else
            tape.status = 0     #新卷
          end
          tape.tape_num = tape_num
          tape.save
        end
		  end
		end
	end
end

require 'spreadsheet'

module TapesHelper
	# File_root = '/js/sydz/dzoas/tapes.xls'
	File_root = '/home/wwwroot/www.dazhangoa.com/public/upload/public_file/tapes.xls'

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
		where = params.permit(:from, :place, :texture, :size, :status).delete_if{|key,value| value.empty?}
		where = where.merge(add_where) if add_where != nil
		unless params[:size].empty?
			size = params[:size].split("*")
			where = where.merge(thickness: size[0], wide: size[1]).delete_if{|key,value| key=='size'}
		end
    	Tape.where(where)
	end

	#上传文件
	def ex_upload(file_field)
        File.open(File_root, "wb+") do |f|
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
		book = Spreadsheet.open File_root
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

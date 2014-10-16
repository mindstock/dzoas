# encoding: utf-8
module PlansHelper
	To_phone = {
      "3" => ["15707287529@139.com"]
  	}

  	To_Message_Phone = {
  		"1" => ["13997829964@139.com"],         #水光丽
  		"3" => ["13720158000@139.com"],			#余总
  		"2" => ["13986888809@139.com"],			#关博
  		"4" => ["13971931941@139.com"],			#倪总
  		"5" => ["15707287529@139.com"]

  	}

	def create_html tape_id, index
		html = <<-EOF
        <hr>
        <table width="95%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="90" height="24" class="td_form01">规格(厚x宽x长)</td>
          <td class="td_form02">
            <input type="text" class="input required" id="new_size#{tape_id}-#{index}" name="new_size#{tape_id}-#{index}">
          </td>
          <td width="90" class="td_form01">加工张数</td>
          <td class="td_form02">
              <input type="text" class="input required" id="final_sheet#{tape_id}-#{index}" name="final_sheet#{tape_id}-#{index}">
          </td>
          <td class="td_form01">送往单位</td>
          <td class="td_form02">
            <input type="text" class="input required" id="to#{tape_id}-#{index}" name="to#{tape_id}-#{index}">
          </td>
        </tr>
        <tr>
          <td height="24" class="td_form01">重要程度</td>
          <td class="td_form02">
            <select class="input" id="is_urgency#{tape_id}-#{index}" name="is_urgency#{tape_id}-#{index}">
              	<option value="0" selected>一般</option>
              	<option value="1">紧急</option>
            </select>
          </td>
          <td height="24" class="td_form01">是否表面件</td>
          <td class="td_form02">
            <input type="radio" name="is_declicacy#{tape_id}-#{index}" id="is_declicacy#{tape_id}-#{index}" value="1">是
            <input type="radio" name="is_declicacy#{tape_id}-#{index}" id="is_declicacy#{tape_id}-#{index}" value="0" checked>否
          </td>
          <td class="td_form01">公差</td>
          <td class="td_form02">
            <input type="radio" name="allowance#{tape_id}-#{index}" id="allowance#{tape_id}-#{index}" value="+0.5" checked>+0.5
            <input type="radio" name="allowance#{tape_id}-#{index}" id="allowance#{tape_id}-#{index}" value="-0.5">-0.5
	        <input type="radio" name="allowance#{tape_id}-#{index}" id="allowance#{tape_id}-#{index}" value="+1">+1
          </td>
        </tr>
        <tr>
          <td height="24" class="td_form01">完工日期</td>
          <td class="td_form02">
            <input type="date" class="input required" name="finish_at#{tape_id}-#{index}" id="finish_at#{tape_id}-#{index}" />
          </td>
          <td class="td_form01">备注</td>
          <td class="td_form02" colspan="3">
            <textarea class="input" rows="2" id="remark#{tape_id}-#{index}" name="remark#{tape_id}-#{index}"></textarea>
          </td>
        </tr>
      </table>
		EOF
	end

	def plan_update id, field, value
		plan = Plan.find_by(id: id)
		_hash = {field => value}
		plan.update(_hash)
	end

	def plan_update_status_by_tape tape_id, status
		Plan.connection.execute("update plans set status = '#{status}' where tape_id=#{tape_id}")
	end

	def plan_update_by_hash id, params
		plan = Plan.find_by(id: id)
		plan.update(params)
	end

	def edit_nickelclad merge, params
		merge = Nickelclad.find_by(merge: merge)
		merge.update(params)
	end

	def edit_nickelclad_length merge, length, new_legth
		Nickelclad.connection.execute("update nickelclads set length = '#{new_legth}' where merge='#{merge}' and length='#{length}'")
		
	end

	def update_tape_status id, status
		tape = Tape.find_by(id: id)
		tape.update(status: status)
	end

	def update_status_by_status id, status
		plan = Plan.find_by(id: id)
		plan.update(status: status)
	end

	def update_final_sheet final_sheet, real_final_sheet, merge
		sql = "SELECT * FROM plans where tape_merge='#{merge}' and final_sheet <= '#{final_sheet}' limit 2;"
		plans = Plan.find_by_sql(sql)
		if plans.size == 2
			count = "全开"
			if final_sheet != "全开" and final_sheet.to_i > 0
				count = final_sheet.to_i - real_final_sheet.to_i 
			end	
				count = "全开" if count.to_i <= 0

			

			Plan.connection.execute("update plans set final_sheet = '#{count}' where id = #{plans[1].id}")
		end
	end

	def create_plan_by_ids ids
		ids.each do |id|
			Plan.connection.execute("update plans set status=0 where id = #{id.to_i}")
		end
		
	end

	#根据条件获取计划列表 history: 1当前  2：历史
	def get_list history, department, finish_at, cur_page
		where = ""
		where = "and finish_at = '#{finish_at}'" if finish_at and !finish_at.empty?
			
		if history.to_i == 1
			Plan.where("status >=0 and status < 4 and department_id = #{department} #{where}").order(id: :asc)
		elsif history.to_i == 2
			Plan.where("department_id = #{department} and status >= 4 #{where}").order(finish_at: :desc).page(cur_page)
		else
			Plan.where("status = -1 and department_id = #{department} #{where}").order(finish_at: :asc)
		end
	end

	def send_mail_by_status status, plan
		if status.to_i == 3
			To_phone[status.to_s].each do |phone|
				params = {
		        :to => phone,
		        :subject => "大章邮件通知",
		        :title => "开平检查",
		        :content => "计划id:#{plan.id},原规格：#{plan.tape.thickness}x#{plan.tape.wide}x#{plan.tape.length}, 
		        现规格:#{plan.nickelclad.thickness}x#{plan.nickelclad.wide}x#{plan.nickelclad.length}"
		      }
		      PlanMailer.send_mail(params).deliver
			end
	      
    	end
	end

	def send_size_message message, employee_id, type
		params = {}
		if type == 0
			params = {
			        :to => Employee.find(employee_id).phone<<"@139.com",
			        :subject => "大章邮件通知",
			        :title => "钢卷规格",
			        :content => message	
			    }
		else
			params = {
			        :to => To_Message_Phone[employee_id.to_s],
			        :subject => "大章邮件通知",
			        :title => "短信通知",
			        :content => "开平组因钢卷开平问题有事儿找您，请收到短信后到开平线！"	
			    }
		end
		PlanMailer.send_mail(params).deliver


	end

	def add_nickelclad size, is_declicacy, allowance, merge, to, final_sheet
		thickness, wide, length = size.split('*')
		_nickelclad = Nickelclad.new
		_nickelclad.merge = merge
		_nickelclad.thickness = thickness
		_nickelclad.wide = wide
		_nickelclad.length = length
		_nickelclad.allowance = allowance
		_nickelclad.to = to
		_nickelclad.is_declicacy = is_declicacy
		_nickelclad.status = 0
		_nickelclad
	end

	def update_nickelclad merge, count

		Nickelclad.connection.execute("update nickelclads set merge='#{merge}-#{count}' where merge = '#{merge}'")
		Plan.connection.execute("update plans set tape_merge='#{merge}-#{count}' where tape_merge = '#{merge}'")
	end


	def add_plans params
		tape_ids = params[:tape_ids].split(",")
		merge = Time.now.strftime("%Y%m%d%H%M%S").to_s + rand(0xffffff).to_s
		_length = []
		count = 0



		tape_ids.each_with_index do |tape, num|
			index = params["index#{tape}"].to_i
			#更新钢卷状态
			update_tape_status tape, params["status#{tape}"].to_i

			department_id = params["department_id"]
			index.times do |index|
				plan = Plan.new()
				plan.department_id = department_id
				plan.tape_id = tape
				_tmp = "#{tape}-#{index+1}"
				plan.tape_merge = merge
				plan.finish_at = params["finish_at#{_tmp}"]
				#是否重要
				plan.is_urgency = params["is_urgency#{_tmp}"].to_i
				plan.remark = params["remark#{_tmp}"]
				plan.final_sheet = params["final_sheet#{_tmp}"]

				length = params["new_size#{_tmp}"].split("*")[2] 
				plan.status = -1
				if num == 0
					count += 1
					plan.nickelclad = add_nickelclad params["new_size#{_tmp}"], params["is_declicacy#{_tmp}"].to_i, params["allowance#{_tmp}"], merge, params["to#{_tmp}"], params["final_sheet#{_tmp}"]
					plan.save 
				elsif num != 0 and index.size == 1
					count += 1
					plan.nickelclad = add_nickelclad params["new_size#{_tmp}"], params["is_declicacy#{_tmp}"].to_i, params["allowance#{_tmp}"], merge, params["to#{_tmp}"], params["final_sheet#{_tmp}"]
					plan.save 
				else !_length.include? length
					count += 1
					plan.nickelclad = add_nickelclad params["new_size#{_tmp}"], params["is_declicacy#{_tmp}"].to_i, params["allowance#{_tmp}"], merge, params["to#{_tmp}"], params["final_sheet#{_tmp}"]
					plan.save 
				end
				
				_length << length
			end
		end

		update_nickelclad merge, count
		
	end
end
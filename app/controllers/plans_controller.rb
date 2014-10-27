# encoding: utf-8
class PlansController < ApplicationController

  #库存辅助类
  include TapesHelper
  include PlansHelper
  include NickelcladsHelper
  include BagsHelper

  protect_from_forgery :except => [:add_place_num]

  before_action :set_plan, only: [:show, :edit, :update, :destroy]
  before_action :search_init, only: [:search_tapes, :search]
  before_action :set_plan_status, only: [:index, :spread]

  # GET /plans
  # GET /plans.json
  def index
    user_session[:menu] = params[:menu]
    department = params[:department] ||= 1
    history = params[:history] ||= 1
    finish_at = params[:finish_at]
    @plans = get_list(history, department, finish_at, params[:page])
    @view_params = {history: history.to_i, department: department, finish_at: finish_at}
    template = {
      1 => "index",
      2 => "complete_index",
      -1 => "index"
    }
    @role = user_session[:role]
    render(:template => "plans/#{template[history.to_i]}") 
  end

  def guest_index
    redirect_to '/plans?menu=10&role=1'
  end

  def show
    plan = Plan.find(params[:id].to_i)
    @plans = Plan.where(tape_id: plan.tape.id, status: 4)
    @quclity_checks = QuclityCheck.where(plan_id: plan.id)
    render(:layout => "head") if params[:type].to_i == 1
  end

  def get_format_html
    json = {html: create_html(params[:tape_id], params[:index])}
    render :json => json, status => "200 ok"
  end

  # GET /plans/new
  def new
    tape_ids = params[:tapes_id].split(",")
    @tapes = get_tapes_by_ids tape_ids
    @plan = Plan.new
    @tomorrow = get_tomorrow
    @new_size, @department_id = params[:new_size], params["department"]
    @ids, @tape_merge = params[:tapes_id], "#{tape_ids.length}-#{Time.now.strftime("%Y%m%d%H%M%S")}"
  end

  def spread
    department = params[:department].to_i ||= 1
    history = params[:history] ||= 1
    finish_at = params[:finish_at]
    @plans = get_list(history, department, finish_at,params[:page])

    template = {
      1 => {
        1 => "spread_kaiping",
        2 => "spread_jianqie",
        3 => "spread_reban"
      },
      2 => {
        1 => "complete_spread_kaiping"
      }
    }
    @view_params = {history: history.to_i, department: department, finish_at: finish_at}
    @quclity_check = QuclityCheck.new
    @employees = Employee.all

    render(:template => "plans/#{template[history.to_i][department]}", :layout => "head") 
  end

  def check_plan_status status = 0
    count = Plan.where(status: status, department_id: params[:department].to_i).count
    json = {count: count}
    json = {count: count, stop: 1, ip: request.ip} if params[:stop].to_i == 1
    render :json => json, status => "200 ok"
  end

  def add_place_num
    tape_id, place_num = params[:tape_id].to_i, params[:place_num]
    status = 2
    plan_update_status_by_tape tape_id, status
    update_place_num tape_id, place_num, status unless params[:place_num].empty?
    redirect_to "/plans/spread/1"
  end

  def update_status

    @plan = Plan.find(params["id"])
    id, status = params["id"], params["status"].to_i
    # send_mail_by_status status, @plan
    if status == 4
      @plans = Plan.where(tape_id: @plan.tape.id, status: 4)
      render :template => "plans/complete_plan", :layout => false
    elsif status == 2 or status ==1
      plan_update_status_by_tape @plan.tape.id, status
      redirect_to "/plans/spread/1"
    else
      update_status_by_status id, status
      update_order @plan.tape_merge
      redirect_to "/plans/spread/1"
    end
  end

  def complete_plan
    plan_id = params[:id]    #得到计划id
    plan = Plan.find(plan_id)
    tape, nickelclad = plan.tape, plan.nickelclad
    unless params[:sheet].empty?
      bag = Bag.new
      bag.sheet = params[:sheet]
      bag.is_nickelclad_top = params[:is_nickelclad_top].to_i
      bag.nickelclad_id = nickelclad.id
      bag.save
    end
    
    #更新任务状态
    update_status_by_status plan_id, 4  #更新任务状态

    #真实剪切张数
    real_final_sheet = Bag.where(nickelclad_id: plan.nickelclad.id, is_nickelclad_top: 0).sum("sheet").to_i
    #更新完成时间 更新计划剪切件数
    plan_update_by_hash plan_id.to_i, {real_finish_at: Time.now.strftime("%Y-%m-%d %H:%M"), real_final_sheet: real_final_sheet}
    #计算剩余卷重= 
    out_weight = tape.out_weight.to_i
    residue_weight = _residue_weight = tape.residue_weight.to_i

    plan_num = Plan.where(tape_id: tape, status: [-1, 0, 1, 2, 3]).count
    if tape.status == 1
      residue_weight = _residue_weight - (real_final_sheet * 7.85 * (nickelclad.length.to_f / 1000) * (nickelclad.wide.to_f / 1000) * nickelclad.thickness.to_f)
      out_weight = _residue_weight - residue_weight
    else
      if plan_num == 0
        out_weight = out_weight + _residue_weight
        residue_weight = 0
      end
    end
    _hash = {
      "out_weight" => out_weight,
      "residue_weight" => residue_weight
    }
    #更新钢卷库存信息
    tape_update_by_hash plan.tape.id, _hash


    final_sheet = plan.final_sheet
    _nickelclad_params = {
      real_final_sheet: real_final_sheet,
      real_finish_at: Time.now.strftime("%Y-%m-%d %H:%M"),
      status: 1
    }
    nickelclad_update_by_hash plan.nickelclad.id, _nickelclad_params

    update_final_sheet final_sheet, real_final_sheet, plan.tape_merge
    
    redirect_to "/plans/spread/1"
  end

  # POST /plans
  # POST /plans.json
  def create
    add_plans params
    redirect_to '/plans?depratement=1'
  end

  def create_plan
    create_plan_by_ids params['ids'].split(',')
    redirect_to '/plans?depratement=1'
  end



  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    plan_id = params[:plan_id].to_i
    plan = Plan.find(plan_id)
    plan_update_by_hash plan_id, params.permit(:final_sheet, :is_urgency, :finish_at, :remark)
    tape_update_by_hash plan.tape.id, params.permit(:status)

    edit_nickelclad plan.nickelclad.id, params.permit(:is_delicacy, :allowance, :to)
    edit_nickelclad_thickness plan.tape_merge,  params.permit(:size)[:size].split("*")[0]
    edit_nickelclad_length plan.tape_merge, plan.nickelclad.length, params.permit(:size)[:size].split("*")[2]
    redirect_to '/plans'
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def del
    del_plan params[:tape_merge]
    redirect_to '/plans?history=-1'
  end

  def send_message
    type = params[:type] ||= 0
    employee_id = params[:employee_id] ||= 0
    send_size_message params[:message], params[:employee_id], type.to_i
    redirect_to "/plans/spread/1"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plan_status
      @plan_status_class = {
        0 => "btn btn-danger",
        1 => "btn btn-primary",
        2 => "btn btn-warning",
        3 => "btn btn-success"
      }
      @plan_status_name = {
        -1 => "待发布",
        0 => "待接收",
        1 => "待上料",
        2 => "待开始",
        3 => "进行中",
        4 => "完成"
      }
      @plan_status_button = {
        0 => "接收",
        1 => "上料",
        2 => "开始",
        3 => "完成"
      }
      @plan_status_color = {
        0 => "danger",
        3 => "success"
      }
    end
    def search_init
      @tapes = []
      @where = {texture: '', size: ''}
    end

    def set_plan
      @plan = Plan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plan_params
      params.require(:plan).permit(:thickness, :wide, :length, :final_sheet, :final_piece, :final_row, :finish_at, :real_finish_at, :is_urgency, :allowance, :is_declicacy, :to, :status)
    end
end

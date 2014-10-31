# encoding: utf-8
class TapesController < ApplicationController
  #status  —  0:new   1:收卷   2：用完   3：外厂
  include TapesHelper
  before_action :set_tape, only: [:show, :edit, :update, :destroy]
  before_action :set_where, only:[:index]
  before_action :status_info, only:[:index, :search, :plan_search]
  before_action :search_init, only:[:plan_search]
  before_action :tape_out_info, only:[:index, :plan_search, :search]

  #上传excel
  def upload
    file = ex_upload(params[:raw_file])
    read_file
    redirect_to '/tapes'
  end

  #库存查找
  def search
    @where = params.delete_if{|key, value| value == "all"}
    @tapes = tapes_search(@where)
    render :action => 'index'
  end

  def plan_search
    @tapes = tapes_search(params, {status: [0, 1, 3]}) if !params[:size].empty? and params[:size].split("*")[2].to_i != 0
    @where = params
    render(:template => "plans/search_tapes") 
  end

  # GET /tapes
  # GET /tapes.json
  def index
    user_session[:menu] = params[:menu]
    type = params[:type] ||= 'all'
    @tapes = get_list params[:page], type
  end

  # GET /tapes/1
  # GET /tapes/1.json
  def show
  end

  # GET /tapes/new
  def new
    @tape = Tape.new
  end

  # GET /tapes/1/edit
  def edit
  end

  

  # POST /tapes
  # POST /tapes.json
  def create
    @tape = Tape.new(tape_params)
    @tape.save

    redirect_to '/tapes'
  end

  # PATCH/PUT /tapes/1
  # PATCH/PUT /tapes/1.json
  def update
    respond_to do |format|
      if @tape.update(tape_params)
        format.html { redirect_to @tape, notice: 'Tape was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tape.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tapes/1
  # DELETE /tapes/1.json
  def destroy
    @tape.destroy
    respond_to do |format|
      format.html { redirect_to tapes_url }
      format.json { head :no_content }
    end
  end

  private
    def set_where
      @where = {from: '', texture: '', place: '', size: ''}
      
    end

    def status_info
      @status_info = {
        "all" => "所有",
        0 => "新卷",
        1 => "收卷",
        2 => "已用完",
        3 => "存外厂"
      }
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_tape
      @tape = Tape.find(params[:id])
    end

    def search_init
      @tapes = []
      @where = {texture: '', size: ''}
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tape_params
      params.permit(:from, :place, :texture, :thickness, :wide, :length, :raw_weight, :put_weight, :out_weight, :residue_weight, :tape_num)
    end

    def tape_out_info
      @day = get_out_weight 'day'
      @month = get_out_weight 'month'
      @year = get_out_weight 'year'
    end
end

class QuclityChecksController < ApplicationController
  before_action :set_quclity_check, only: [:show, :edit, :update, :destroy]

  # GET /quclity_checks
  # GET /quclity_checks.json
  def index
    @quclity_checks = QuclityCheck.all
  end

  # GET /quclity_checks/1
  # GET /quclity_checks/1.json
  def show
  end

  # GET /quclity_checks/new
  def new
    @quclity_check = QuclityCheck.new
    @plan_id = params[:plan_id]
    @quclity_checks = QuclityCheck.where(plan_id: params[:plan_id]).order(created_at: :desc)
    render :layout => false
  end

  # GET /quclity_checks/1/edit
  def edit
  end

  # POST /quclity_checks
  # POST /quclity_checks.json
  def create
    @quclity_check = QuclityCheck.new(quclity_check_params)
    @quclity_check.save
    redirect_to "/plans/spread/1"
    
  end

  # PATCH/PUT /quclity_checks/1
  # PATCH/PUT /quclity_checks/1.json
  def update
    respond_to do |format|
      if @quclity_check.update(quclity_check_params)
        format.html { redirect_to @quclity_check, notice: 'Quclity check was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @quclity_check.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quclity_checks/1
  # DELETE /quclity_checks/1.json
  def destroy
    @quclity_check.destroy
    respond_to do |format|
      format.html { redirect_to quclity_checks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quclity_check
      @quclity_check = QuclityCheck.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quclity_check_params
      params.permit(:plan_id, :remark, :is_standard)
    end

end

class NickelcladsController < ApplicationController
  before_action :set_nickelclad, only: [:show, :edit, :update, :destroy]

  # GET /nickelclads
  # GET /nickelclads.json
  def index
    user_session[:menu] = params[:menu] 
    @nickelclads = Nickelclad.all
  end

  # GET /nickelclads/1
  # GET /nickelclads/1.json
  def show
  end

  # GET /nickelclads/new
  def new
    @nickelclad = Nickelclad.new
  end

  # GET /nickelclads/1/edit
  def edit
  end

  # POST /nickelclads
  # POST /nickelclads.json
  def create
    @nickelclad = Nickelclad.new(nickelclad_params)

    respond_to do |format|
      if @nickelclad.save
        format.html { redirect_to @nickelclad, notice: 'Nickelclad was successfully created.' }
        format.json { render action: 'show', status: :created, location: @nickelclad }
      else
        format.html { render action: 'new' }
        format.json { render json: @nickelclad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nickelclads/1
  # PATCH/PUT /nickelclads/1.json
  def update
    respond_to do |format|
      if @nickelclad.update(nickelclad_params)
        format.html { redirect_to @nickelclad, notice: 'Nickelclad was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @nickelclad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nickelclads/1
  # DELETE /nickelclads/1.json
  def destroy
    @nickelclad.destroy
    respond_to do |format|
      format.html { redirect_to nickelclads_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nickelclad
      @nickelclad = Nickelclad.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nickelclad_params
      params.require(:nickelclad).permit(:thickness, :wide, :length, :to, :allowance, :is_declicacy)
    end
end

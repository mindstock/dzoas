class PowersController < ApplicationController
  include PowersHelper
  before_action :set_power, only: [:show, :edit, :update, :del]
  before_action :power_all, only: [:index, :new, :edit]

  def index
    user_session[:menu] = params[:menu]
    # get_navigation user_session[:menu]
    @powers = Power.all
  end

  def new
    @power = Power.new
  end

  def edit
  end

  def create
    if params[:id] and !params[:id].empty?
      power = Power.find(params[:id])
      power.update power_params
    else
      @power = Power.new(power_params)
      @power.save
    end
    
    redirect_to '/powers'
  end

  def update
    @power.update(power_params)
  end

  def del
    Power.connection.execute("delete from powers where id = #{params[:id]}")
    redirect_to '/powers'
    # @power.destroy
  end

  private
    def power_all
      @powers = Power.all
    end
    def set_power
      @power = Power.find(params[:id])
    end

    def power_params
      params.permit(:parent_id, :name, :url, :remark)
    end
end

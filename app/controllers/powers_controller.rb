class PowersController < ApplicationController
  before_action :set_power, only: [:show, :edit, :update, :destroy]

  def index
    @powers = Power.all
  end

  def new
    @power = Power.new
  end

  def edit
  end

  def create
    @power = Power.new(power_params)
    @power.save
  end

  def update
    @power.update(power_params)
  end

  def destroy
    @power.destroy
  end

  private
    def set_power
      @power = Power.find(params[:id])
    end

    def power_params
      params.require(:power).permit(:parent_id, :name, :url, :remark)
    end
end

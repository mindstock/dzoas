class BagsController < ApplicationController
  include BagsHelper
  include PlansHelper
  include NickelcladsHelper

  before_action :set_bag, only: [:show, :edit, :update, :destroy]

  def index
    @bags = Bag.all
    respond_with(@bags)
  end

  def show
    respond_with(@bag)
  end

  def new
    @bag = Bag.new
    respond_with(@bag)
  end
  def edit
  end

  def create
    unless bag_params[:sheet].empty?
      nickelclad_id, complete_plan_id = bag_params[:nickelclad_id], bag_params[:complete_plan_id]
      sheet_split bag_params
      sheet = bat_sheet(nickelclad_id)
      plan_update_by_hash bag_params[:complete_plan_id], {real_final_sheet: sheet}
      nickelclad_update_by_hash bag_params[:nickelclad_id], {real_final_sheet: sheet}
    end
    redirect_to '/plans/check/list/1?menu=7'
  end

  def update
    @bag.update(bag_params)
    respond_with(@bag)
  end

  def destroy
    @bag.destroy
    respond_with(@bag)
  end

  private
    def set_bag
      @bag = Bag.find(params[:id])
    end

    def bag_params
      params.permit(:sheet, :is_nickelclad_top, :nickelclad_id, :complete_plan_id)
    end
end

class BagsController < ApplicationController
  include BagsHelper
  include PlansHelper
  include NickelcladsHelper

  before_action :set_bag, only: [:show, :edit, :update, :destroy]

  def index
    nickelclad_id = params[:nickelclad_id]
    @nickelclad = Nickelclad.find(nickelclad_id)
    # @bags = Bag.all
    # respond_with(@bags)
  end

  def show
    # respond_with(@bag)
  end

  def new
    @bag = Bag.new
    # respond_with(@bag)
  end
  def edit
  end

  def create
    if !params[:id]
      unless bag_params[:sheet].empty?
        nickelclad_id, complete_plan_id = bag_params[:nickelclad_id], bag_params[:complete_plan_id]
        sheet_split bag_params
        sheet = bat_sheet(nickelclad_id)
        plan_update_by_hash bag_params[:complete_plan_id], {real_final_sheet: sheet}
        nickelclad_update_by_hash bag_params[:nickelclad_id], {real_final_sheet: sheet}
      end
      redirect_to '/plans/check/list/1?menu=7'
    else
      bag = Bag.find(params[:id])
      bag.update(bag_params)
      redirect_to "/bags?nickelclad_id=#{bag_params[:nickelclad_id]}"
    end
    
  end

  def del
    id = params[:id]
    bag = Bag.find params[:id]
    nickelclad_id = bag.nickelclad_id
    bag.destroy
    redirect_to "/bags?nickelclad_id=#{nickelclad_id}"
  end

  def update

    # respond_with(@bag)
  end

  def destroy
    @bag.destroy
    
    # respond_with(@bag)
  end

  private
    def set_bag
      @bag = Bag.find(params[:id])
    end

    def bag_params
      params.permit(:sheet, :is_nickelclad_top, :nickelclad_id, :complete_plan_id)
    end
end

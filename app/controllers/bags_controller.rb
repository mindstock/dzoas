class BagsController < ApplicationController
  include BagsHelper

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
      @bag = Bag.new(bag_params)
      @bag.save 
    end
    redirect_to '/plans/spread/1'
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
      params.permit(:sheet, :is_nickelclad_top, :nickelclad_id)
    end
end

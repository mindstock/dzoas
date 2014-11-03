class ListensController < ApplicationController
  before_action :set_listen, only: [:show, :edit, :update, :destroy]

  def index
    @listens = Listen.all
    respond_with(@listens)
  end

  def show
    respond_with(@listen)
  end

  def new
    @listen = Listen.new
    respond_with(@listen)
  end

  def edit
  end

  def create
    @listen = Listen.new(listen_params)
    @listen.save
    respond_with(@listen)
  end

  def update
    @listen.update(listen_params)
    respond_with(@listen)
  end

  def destroy
    @listen.destroy
    respond_with(@listen)
  end

  private
    def set_listen
      @listen = Listen.find(params[:id])
    end

    def listen_params
      params.require(:listen).permit(:plan_type, :first_status, :last_status)
    end
end

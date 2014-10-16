class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def index
    user_session[:menu] = params[:menu]
    @messages = Message.all
  end

  def show
    
  end

  def new
    @message = Message.new
    
  end

  def edit
  end

  def create
    @message = Message.new(message_params)
    @message.save
    
  end

  def update
    @message.update(message_params)
    
  end

  def destroy
    @message.destroy
    
  end

  private
    def set_message
      @message = Message.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:title, :content, :complete_at, :remark, :type, :status)
    end
end

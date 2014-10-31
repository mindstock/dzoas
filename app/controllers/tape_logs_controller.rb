class TapeLogsController < ApplicationController
  before_action :set_tape_log, only: [:show, :edit, :update, :destroy]

  def index
    @tape_logs = TapeLog.all
    respond_with(@tape_logs)
  end

  def show
    respond_with(@tape_log)
  end

  def new
    @tape_log = TapeLog.new
    respond_with(@tape_log)
  end

  def edit
  end

  def create
    @tape_log = TapeLog.new(tape_log_params)
    @tape_log.save
    respond_with(@tape_log)
  end

  def update
    @tape_log.update(tape_log_params)
    respond_with(@tape_log)
  end

  def destroy
    @tape_log.destroy
    respond_with(@tape_log)
  end

  private
    def set_tape_log
      @tape_log = TapeLog.find(params[:id])
    end

    def tape_log_params
      params.require(:tape_log).permit(:type, :num, :finish_at)
    end
end

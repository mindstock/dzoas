class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def index
    @groups = Group.all
    # respond_with(@groups)
  end

  def show
    # respond_with(@group)
  end

  def new
    @group = Group.new
    @groups = Group.all
    # respond_with(@group)
  end

  def edit
  end

  def create
    @group = Group.new(group_params)
    @group.save
    redirect_to '/groups'

    # respond_with(@group)
  end

  def update
    @group.update(group_params)
    # respond_with(@group)
  end

  def destroy
    @group.destroy
    # respond_with(@group)
  end

  private
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.permit(:title, :remark, :manager_id)
    end
end

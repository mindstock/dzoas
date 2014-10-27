class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  def index
    user_session[:menu] = params[:menu]
    @roles = Role.all
  end

  def show
    respond_with(@role)
  end

  def new
    @role = Role.new
  end

  def edit
  end

  def create
    if params[:id].empty?
      @role = Role.new(role_params)
      @role.save
    else
      @role = Role.find(params[:id])
      @role.update(role_params)
    end
    redirect_to '/roles'
  end

  def update
    @role.update(role_params)
    redirect_to '/roles'
  end

  def destroy
    @role.destroy
    redirect_to '/roles'
  end

  private
    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params.permit(:name, :remark, :parent_id, :id)
    end
end

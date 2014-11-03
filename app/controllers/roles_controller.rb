class RolesController < ApplicationController
  include RolesHelper
  include RolesHelper
  
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  before_action :set_powers, only: [:new, :edit]

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
      @power_ids = get_power_ids_by_role_id @role.id
  end

  def create
    if params[:id].empty?
      @role = Role.new(role_params)
      @role.save
    else
      @role = Role.find(params[:id])
      @role.update(role_params)
      del_power @role.id
      add_power @role.id, params[:power_id].split(',')
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

    def set_powers
      @powers = Power.all

    end
    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params.permit(:name, :remark, :parent_id, :id)
    end
end

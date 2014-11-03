class EmployeesController < ApplicationController
  include EmployeesHelper
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  # GET /employees
  # GET /employees.json
  def index
    user_session[:menu] = params[:menu]
    @employees = Employee.all
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
  end

  # GET /employees/new
  def new
      @employee = Employee.new
      @departments = Department.all
  end

  def new_sys
    @roles = Role.all
  end

  def sys
    user_session[:menu] = params[:menu]
    @users = User.all
  end

  def sys_del
    user_id = params[:user_id]
    sys_user_del user_id
    redirect_to '/employees/sys/users/list'
  end

  def sys_edit
    @user = User.find(params[:user_id])
    @roles = Role.all
  end

  def sys_edit_save
   user = User.find params[:id]
   user.update params.permit(:username, :role_id)
   redirect_to '/employees/sys/users/list'
  end


  # GET /employees/1/edit
  def edit
    @departments = Department.all
  end

  # POST /employees
  # POST /employees.json
  def create
    if params[:type].to_i == 1
      count = Employee.connection.execute("select * from users where username='#{params[:name]}'")
      size = count.count
      if size <= 0
        Employee.connection.execute("insert into users(encrypted_password, username, role_id) values('$2a$10$3lU9fB8kJF6VOj4aSsyLXu.96GSvk2YCrrU83mfL6QqXDkjbZNl6i','#{params[:name]}','#{params[:role_id].to_i}')")
      end
      redirect_to "/"
    else
      @employee = Employee.new(employee_params)
      _r = employee_params[:id].empty? ? @employee.save : Employee.update(employee_params[:id],employee_params)
      redirect_to "/employees/sys/users/list?menu=13"
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.permit(:id, :name, :address, :phone, :department_id)
    end
end

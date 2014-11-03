# encoding: utf-8
class ApplicationController < ActionController::Base
	  include PowersHelper
    include RolesHelper
  	# Prevent CSRF attacks by raising an exception.
  	# For APIs, you may want to use :null_session instead.
  	before_filter :authenticate_user!
  
  	protect_from_forgery with: :exception

  	before_filter :nav

  	def nav
  		if user_signed_in?
  			user_session[:role] = "访客" if current_user.role.name != "超级管理员"
        @power_ids = get_power_ids_by_role_id current_user.role.id
        @html = get_navigation params[:menu], @power_ids

  		end

  		
  	end

end

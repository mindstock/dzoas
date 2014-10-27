# encoding: utf-8
class ApplicationController < ActionController::Base
	include PowersHelper
  	# Prevent CSRF attacks by raising an exception.
  	# For APIs, you may want to use :null_session instead.
  	before_filter :authenticate_user!
  
  	protect_from_forgery with: :exception

  	before_filter :nav

  	def nav
  		if user_signed_in?
  			user_session[:role] = "访客" if current_user.role.name == "访客"
  		end
  		# @html = get_navigation params[:menu]
  	end

end

class ApplicationController < ActionController::Base
	include SessionsHelper

	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	before_action :set_locale

	# デフォルトのURLにロケール情報を入れる
	# def default_url_options( options={} )
	# 	{ locale: I18n.locale }.merge options
	# end

	def set_locale
		# I18n.locale = params[:locale] || I18n.default_locale
		I18n.locale = I18n.default_locale
	end

end

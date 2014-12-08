class MicropostsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy]
	before_action :correct_user, only: :destroy

	def create
		@micropost = current_user.microposts.build( micropost_params )
		if @micropost.save
			flash[ :success ] = I18n.t('microposts.micropost.post_successed')
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		# @micropost.image = nil
		# @micropost.save
		redirect_to root_url
	end

	private
		def micropost_params
			params.require( :micropost ).permit( :content, :image )
			# params.require( :micropost ).permit( :image )
		end

		# def correct_user
		# 	@micropost = current_user.microposts.find_by( id: params[ :id ] )
		# 	redirect_to root_url if @micropost.nil?
		# end
		def correct_user
			@micropost = current_user.microposts.find( params[ :id ] )
		rescue
			redirect_to root_url
		end
end

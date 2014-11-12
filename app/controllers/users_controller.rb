class UsersController < ApplicationController
  before_action :signed_in_user, only: [ :edit, :update ]

  def show
  	@user = User.find( params[:id] )
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new( user_params )
  	if @user.save
  		sign_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
  	@user = User.find( params[ :id ] )
  end

  def update
  	@user = User.find( params[ :id ] )
  	if @user.update_attributes( user_params )
		# 更新に成功した場合を扱う
		flash[ :success ] = "Profile updated"
		redirect_to @user
	else
		render 'edit'
	end
  end

  private
  	def user_params
  		params.require( :user ).permit( :name, :email, :password,
  										:password_confirmation )
  	end

  	# Before actions
  	def signed_in_user
  		redirect_to signin_url, notice: "Please sign in." unless signed_in?
  		# 冗長に書くとこう
  		# unless signed_in?
  		# 	flash[:notice] = "Please sign in."
  		# 	redirect_to signin_url
  		# end
  	end
end

class UsersController < ApplicationController
  before_action :signed_in_user,  only: [ :index, :edit, :update, :destroy ]
  before_action :correct_user,    only: [ :edit, :update ]
  before_action :admin_user,      only: :destroy

  def index
    @users = User.paginate( page: params[ :page ], per_page: 10 )
  end

  def show
    @user = User.find( params[:id] )
    @microposts = @user.microposts.paginate( page: params[ :page ] )
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new( user_params )
  	if @user.save
  		sign_in @user
  		flash[:success] = I18n.t('users.user.welcome')
  		redirect_to root_path
  	else
  		render 'new'
  	end
  end

  def destroy
    user = User.find( params[ :id ] )
    if current_user? user
      redirect_to( root_path )
    else
      user.destroy
      flash[ :success ] = I18n.t('users.user.destroyed')
      redirect_to users_url
    end
  end

  def edit
  end

  def update
    if @user.update_attributes( user_params )
      # 更新に成功した場合を扱う
      flash[ :success ] = I18n.t('users.user.updated')
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
  	def user_params
  		params.require( :user ).permit(
  			:name, :email, :password, :password_confirmation )
  	end

  	# Before actions

  	def correct_user
  		@user = User.find( params[ :id ] )
  		redirect_to( root_path ) unless current_user?( @user )
  	end

  	def admin_user
  		redirect_to( root_path ) unless current_user.admin?
  	end
end

class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:show]
  before_action :authenticate_user, only:[:show]

  def show
    @tasks = @user.tasks.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:succss] = "ユーザを登録しました。"
      redirect_to @user
    else
      flash.now[:danger] = "ユーザの登録に失敗しました。"
      render :new
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def authenticate_user
    @user = User.find(params[:id])
    unless @current_user == @user
      redirect_to root_url
    end
  end
end

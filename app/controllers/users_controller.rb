class UsersController < ApplicationController
  before_action :authenticate_user!

  # A frequent practice is to place the standard CRUD actions in each controlle
  # in the following order: index, show, new, edit, create, update and destroy.

  def index
    @users = User.order(:email)
    authorize(:user)
  end

  def show
    @user = User.find(params[:id])
    authorize(@user)
  end

  def new
    @user = User.new
    authorize(@user)
  end

  def edit
    @user = User.find(params[:id])
    authorize(@user)
  end

  def update
    @user = User.find(params[:id])
    authorize(@user)
    if @user.update(user_params)
      notice = "The user's email has been updated, and a confirmation email has been sent."
      redirect_to(users_path, notice: notice)
    else
      render :edit
    end
  end

  protected

  def user_params
    params.require(:user).permit(:email)
    # Use this when we add user_name, etc.
    # params.require(:user).permit(:user_name, :email, :password, :password_confirmation)
  end
end

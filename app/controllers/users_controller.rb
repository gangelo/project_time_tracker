class UsersController < ApplicationController
  # A frequent practice is to place the standard CRUD actions in each controlle
  # in the following order: index, show, new, edit, create, update and destroy.

  def index
    @users = User.order(:email)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    if @user.save
      redirect_to users_path
    else
      render :edit
    end
  end

  protected

  def user_params
    params.require(:user).permit(:user_name, :email, :password, :password_confirmation)
  end
end

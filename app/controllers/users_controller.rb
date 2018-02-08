class UsersController < ApplicationController
  before_action :authenticate_user!

  # A frequent practice is to place the standard CRUD actions in each controlle
  # in the following order: index, show, new, edit, create, update and destroy.

  def index
    authorize(:user)
    #@search_criteria = UsersSearchCriteria.none
    @search_criteria = UsersSearchCriteria.new
  end

  def search
    authorize(:user)
    paginate_params = { page: params[:page].presence || 1, per_page: params[:per_page] }
    @search_criteria = UsersSearchCriteria.new(search_params.merge(paginate_params))
    render :index
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

  def destroy
    begin
      @user = User.find(params[:id])
      authorize(@user)
      @user.destroy
      redirect_to users_path, notice: "User #{@user.email} has been deleted"
      return
    rescue ActiveRecord::RecordNotFound
      # TODO: logging
      redirect_to(users_path, notice: "The user could not be deleted.")
      return
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
    # Use this when we add user_name, etc.
    # params.require(:user).permit(:user_name, :email, :password, :password_confirmation)
  end

  def search_params
    puts params
    params.require(:users_search_criteria).permit(:search_string, :search_option)
  end
end

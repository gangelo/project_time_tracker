class HomeController < ApplicationController
  include ApplicationHelper
  
  def index
    if current_user?
      @user_task_times = current_user.all_task_times
    end
  end

  protected
end

class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_task_times = current_user.all_task_times
  end

  def start_task
    user_id = current_user.id
    task_times_id = params[:id].to_i
    task_times = TaskTime.find(task_times_id)
    if task_times.nil? || task_times.user_id != user_id
      redirect_to dashboard_index_path, alert: "You cannot start this task"
      return
    end

    unless task_times.start_time.nil?
      redirect_to dashboard_index_path, alert: "This task is already started"
      return
    end

    # Stop all other tasks.
    current_user.task_times.each do |t|
      force_task_stop(t) unless t.start_time.nil?
    end

    task_times.duration = 0 if task_times.duration.nil?
    task_times.start_time = DateTime.now
    if task_times.save
      redirect_to dashboard_index_path, notice: "The task has been started."
    else
      redirect_to dashboard_index_path, alert: "The task could not be saved."
    end
  end

  def stop_task
    task_times_id = params[:id].to_i
    task_times = TaskTime.find(task_times_id)
    if task_times.nil? || task_times.user_id != current_user.id
      redirect_to dashboard_index_path, alert: "You cannot stop this task" and return
    end

    if task_times.start_time.nil?
      redirect_to dashboard_index_path, alert: "This task is already stopped" and return
    end

    if force_task_stop(task_times)
      redirect_to dashboard_index_path, notice: "Task stopped."
    else
      redirect_to dashboard_index_path, alert: "The task could not be saved."
    end
  end

  protected

  def force_task_stop(task_times)
    start_time = task_times.start_time

    duration = task_times.duration || 0
    duration += ((DateTime.now - DateTime.parse(start_time.to_s(:rfc822))) * 24 * 60 * 60).to_i
    task_times.duration = duration
    task_times.start_time = nil
    task_times.save
  end

  def task_params
    params.require(:user_task_times).permit(:task_times_id)
  end
end

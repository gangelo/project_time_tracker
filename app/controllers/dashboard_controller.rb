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

  def edit_note
    user_id = current_user.id
    task_time_id = params[:id].to_i
    @task_time = TaskTime.find(task_time_id)
    if @task_time.nil? || @task_time.user_id != user_id
      redirect_to dashboard_index_path, alert: "You cannot edit the note for this task"
      return
    end
  end

  def update_note
    user_id = current_user.id
    task_time_id = params[:id].to_i
    @task_time = TaskTime.find(task_time_id)
    if @task_time.nil? || @task_time.user_id != user_id
      redirect_to dashboard_index_path, alert: "You cannot update a note for this task"
      return
    end

    task_note = update_note_params[:note]
    task_note.strip!

    if params[:delete_note].present?
      task_note = nil
    else
      if task_note.blank?
        @task_time.errors.add(:note, 'is required')
        render :edit_note and return
      end
    end

    @task_time.note = task_note

    if @task_time.save
      notice = "The task note has been updated."
      redirect_to(dashboard_index_path, notice: notice)
    else
      render :edit_note
    end
  end

  #def destroy_note
  #end

  def new_task_time
    @task_time = TaskTime.new
    @companies = [] #Company.all.order(:name)
    @projects = []
    @tasks = []
  end

  def create_task_time
  end

  def companies
    companies = Company.order(:name)
    render json: companies
  end

  def projects
    company = Company.find(params[:company_id])
    projects = company.projects
    render json: projects
  end

  def tasks
    project = Project.find(params[:project_id])
    tasks = project.tasks.any? ? project.tasks.order(:name) : []
    render json: tasks
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

  def create_task_time_params
    params.require(:task_time).permit(:note)
  end

  def update_note_params
    params.require(:task_time).permit(:note)
  end
end

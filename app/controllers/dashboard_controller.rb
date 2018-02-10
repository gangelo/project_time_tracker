class DashboardController < ApplicationController
  include DashboardHelper
  
  before_action :authenticate_user!

  def index
    @user_task_times = current_user.all_task_times
  end

  def start_task
    task_time_id = params[:id].to_i
    task_time = task_time_for_current_user(task_time_id) do |error|
      redirect_to dashboard_index_path, alert: "You cannot start this task" and return
    end

    unless task_time.start_time.nil?
      redirect_to dashboard_index_path, alert: "This task is already started"
      return
    end

    # Stop all other tasks.
    current_user.task_times.each do |t|
      force_task_stop(t) unless t.start_time.nil?
    end

    task_time.duration = 0 if task_time.duration.nil?
    task_time.start_time = DateTime.now
    if task_time.save
      redirect_to dashboard_index_path
    else
      redirect_to dashboard_index_path, alert: "The task could not be saved."
    end
  end

  def stop_task
    task_time_id = params[:id].to_i
    task_time = task_time_for_current_user(task_time_id) do |error|
      redirect_to dashboard_index_path, alert: "You cannot stop this task" and return
    end

    if task_time.start_time.nil?
      redirect_to dashboard_index_path, alert: "This task is already stopped" and return
    end

    if force_task_stop(task_time)
      redirect_to dashboard_index_path
    else
      redirect_to dashboard_index_path, alert: "The task could not be saved."
    end
  end

  def edit_duration
    task_time_id = params[:id].to_i
    @task_time = task_time_for_current_user(task_time_id) do |error|
      redirect_to dashboard_index_path, alert: error and return
    end
  end

  def update_duration
    task_time_id = params[:id].to_i
    @task_time = task_time_for_current_user(task_time_id) do |error|
      redirect_to dashboard_index_path, alert: error and return
    end

    duration = update_duration_params[:duration]
    if duration.blank? || /[\D]+/.match?(duration)
      @task_time.errors.add(:duration, 'must be numeric')
      render :edit_duration and return
    end

    duration = duration.to_i
    @task_time.duration = duration
    @task_time.start_time = nil

    if @task_time.save
      notice = "The task has been stopped and the duration has been updated."
      redirect_to(dashboard_index_path, notice: notice)
    else
      render :edit_duration, alert: "The duration could not be updated. The task has been stopped."
    end
  end

  def edit_note
    task_time_id = params[:id].to_i
    @task_time = task_time_for_current_user(task_time_id) do |error|
      redirect_to dashboard_index_path, alert: error and return
    end
  end

  def update_note
    task_time_id = params[:id].to_i
    @task_time = task_time_for_current_user(task_time_id) do |error|
      redirect_to dashboard_index_path, alert: error and return
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

  def new_task_time
    @task_time = TaskTime.new
    @companies = []
    @projects = []
    @tasks = []
  end

  def create_task_time
    task_id = create_task_time_params[:tasks]
    current_user.task_times << TaskTime.create(task_id: task_id)
    if current_user.save
      redirect_to dashboard_index_path, notice: "Task time was added"
    else
      render :new_task_time, alert: "Could not save task time"
    end
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
    task_times = current_user.task_times

    rejected_tasks = task_times.map { |t| t.task.id }
    rejected_tasks = rejected_tasks.split(',').join(',') unless rejected_tasks.empty?

    project = Project.find(params[:project_id])

    tasks = rejected_tasks.any? ?
      project.tasks.where("id not in (#{rejected_tasks})").
                          select([:id, :name]).
                          order(:name) :
                          project.tasks.select([:id, :name]).order(:name)

    tasks = tasks.any? ? tasks : []
    render json: tasks
  end

  protected

  def create_task_time_params
    params.permit(:companies, :projects, :tasks)
  end

  def update_note_params
    params.require(:task_time).permit(:note)
  end

  def update_duration_params
    params.require(:task_time).permit(:duration)
  end
end

class UserTaskTimes
  attr_reader :company_name
  attr_reader :project_name
  attr_reader :task_name
  attr_reader :task_duration
  attr_reader :task_times_id
  attr_reader :task_start_time
  attr_reader :task_note
  attr_reader :task_status

  attr_reader :sort_field

  def initialize(user_task_times)
    @task_times_id = user_task_times.id
    @task_note = user_task_times.note
    @company_name = user_task_times.task.project.company.name
    @project_name = user_task_times.task.project.name
    @task_name = user_task_times.task.name
    @task_duration = user_task_times.duration || 0
    @task_start_time = user_task_times.start_time

    @task_status = started? ? "Started" : ""

    # Terrible!
    @sort_field = "#{@company_name}#{@project_name}#{@task_name}"
  end

  def started?
    !stopped?
  end

  def stopped?
    task_start_time.nil?
  end
end

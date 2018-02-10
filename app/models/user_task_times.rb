class UserTaskTimes
  attr_reader :company_name
  attr_reader :project_name
  attr_reader :task_name
  attr_reader :task_duration
  attr_reader :task_times_id
  attr_reader :task_start_time

  attr_reader :sort_field

  def initialize(task_times_id, company_name, project_name,
                 task_name, task_duration, task_start_time)
    @task_times_id = task_times_id
    @company_name = company_name
    @project_name = project_name
    @task_name = task_name
    @task_duration = task_duration
    @task_start_time = task_start_time

    # Terrible!
    @sort_field = "#{company_name}#{project_name}#{task_name}"
  end

  def started?
    !task_start_time.nil?
  end
end

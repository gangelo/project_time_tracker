class UserTaskTimes
  attr_reader :company_name
  attr_reader :project_name
  attr_reader :task_name
  attr_reader :task_duration
  attr_reader :task_time_id
  attr_reader :task_time_note
  attr_reader :task_started
  attr_reader :task_status

  def initialize(company_name, project_name,
                 task_name, task_duration, task_time_id, task_time_note,
                 task_started)
    @company_name = company_name
    @project_name = project_name
    @task_name = task_name
    @task_duration = task_duration
    @task_time_id = task_time_id
    @task_time_note = task_time_note
    @task_started = task_started
  end

  def stopped?
    !started?
  end

  def started?
    task_started
  end
end

class UserTaskTimes
  attr_reader :company_name
  attr_reader :project_name
  attr_reader :task_name
  attr_reader :task_duration

  def initialize(company_name, project_name, task_name, task_duration)
    @company_name = company_name
    @project_name = project_name
    @task_name = task_name
    @task_duration = task_duration
  end
end

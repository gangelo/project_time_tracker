class TaskPolicy < BasePolicy

  def project_tasks?
    return false if user.nil?
    user.admin?
  end
end

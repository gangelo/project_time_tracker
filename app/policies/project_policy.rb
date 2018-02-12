class ProjectPolicy < BasePolicy

  def company_projects?
    return false if user.nil?
    user.admin?
  end
end

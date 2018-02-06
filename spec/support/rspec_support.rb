
module RSpecHelpers
  module Methods
    def force_current_user(current_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user)
    end

    def force_current_user?
      allow_any_instance_of(ApplicationController).to receive(:current_user?).and_return(User)
    end

    def admin_user
      User.admins.first
    end

    def non_admin_user
      User.non_admins.first
    end

    def admin_role
      Role.admin
    end

    def user_role
      Role.user
    end
  end
end

RSpec.configure do |config|
  config.include RSpecHelpers::Methods
end


module RSpecHelpers
  module Methods
    def force_current_user(current_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user)
    end

    def force_current_user?
      allow_any_instance_of(ApplicationController).to receive(:current_user?).and_return(User)
    end

    def get_admin_user
      User.find_by(email: 'admin@gmail.com')
    end

    def admin_role
      Role.find_by(name: 'admin')
    end

    def user_role
      Role.find_by(name: 'user')
    end
  end
end

RSpec.configure do |config|
  config.include RSpecHelpers::Methods
end

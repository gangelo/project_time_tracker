# Redirect to the root_path in the event of a login failure. This change
# is IAW changes made to the /config/initializers/devise.rb and
# /config/application.rb files.
=begin
class DeviseCustomFailure < Devise::FailureApp
  def redirect_url
    root_path
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
=end

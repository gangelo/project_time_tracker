# Redirect to the root_path in the event of a login failure. This change
# is IAW changes made to the /config/initializers/devise.rb and
# /config/application.rb files.
class DeviseCustomFailure < Devise::FailureApp
  @@redirect_url = nil

  def self.redirect_url=(redirect_url)
    @@redirect_url = redirect_url
  end

  def self.redirect_url
    @@redirect_url
  end

  def self.redirect_url?
    !@@redirect_url.blank?
  end

  def redirect_url
    redirect_to_url = DeviseCustomFailure.redirect_url
    DeviseCustomFailure.redirect_url = nil
    redirect_to_url
  end

  def respond
    if http_auth?
      http_auth
    elsif DeviseCustomFailure.redirect_url?
      redirect
    elsif warden_options[:recall]
      recall
    else
      redirect
    end
  end
end

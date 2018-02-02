module ApplicationHelper
 # Returns the authenticated user if one is logged in, or a blank new user if not.
 #
 def resource
   current_user || User.new
 end

 def current_user?
   current_user
 end
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  protected
    def authenticate_user!
      if user_signed_in?
        super
      else
        redirect_to new_user_session_path
      end
    end
    
    def profile_active?
      redirect_to reactivate_account_url if UserProfile.find_by(user_id: current_user.id).active == false
    end
end

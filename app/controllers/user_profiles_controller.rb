class UserProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :profile_doesnt_exist, only: [:new, :create]
    before_action :profile_exists, only: [:show, :update, :destroy, :edit]
    before_action :profile_active?, except: [:activate_user, :reactivate_account]
    
    def new
        @user_profile = UserProfile.new
        @user_profile.build_location
    end
    
    def create
        @user_profile = current_user.build_user_profile(user_profile_params)
        if @user_profile.save
            redirect_to root_url
        else
           render 'new' 
        end
    end
    
    def show 
       @user_profile = UserProfile.find(params[:id]) 
    end
    
    def edit
       @user_profile = UserProfile.find(params[:id])
    end
    
    def update
        @user = UserProfile.find(params[:id])
        if @user.update_attributes(user_profile_params)
            redirect_to root_url
        else
          render 'edit'
        end
    end
    
    def destroy
       @user = UserProfile.find(params[:id])
       @user.update(active: false)
       sign_out current_user
       redirect_to root_url
    end
    
    def reactivate_account
       render 'reactivate_account' 
    end
    
    def activate_user
        #This is the method that sets user activated
        @user = UserProfile.find(params[:id])
        @user.update(active: true)
        redirect_to root_url
    end
    
    private
    
        def profile_exists
            unless UserProfile.exists?(user_id: current_user)
                redirect_to new_user_profile_path
            end
        end
        
        def profile_doesnt_exist
           if UserProfile.exists?(user_id: current_user)
                redirect_to root_url
            end
        end
    
        def user_profile_params
            params.require(:user_profile).permit(:first_name, :last_name, :birth_date, location_attributes: [:lat, :lng])
        end
end
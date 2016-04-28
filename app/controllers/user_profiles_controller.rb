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
        @user_profile = current_user.build_user_profile(user_profile_params.except(:location_attributes, :location_component_attributes))
        
        location_attributes = user_profile_params[:location_attributes]
        lat = location_attributes[:lat].to_d.round(8)
        lng = location_attributes[:lng].to_d.round(8)
        
        # Now I can build the locations by hand
        if Location.exists?(:lat => lat, :lng => lng)
            
            @user_location = Location.find_by(:lat => lat, :lng => lng)
            @user_profile.location_id = @user_location.id
        else
            @user_location = Location.create(:lat => lat, :lng => lng)
            @user_profile.location_id = @user_location.id
            
            user_components = user_profile_params[:location_component_attributes]
            user_components.each do |component, value|
               @user_location.location_components.create(:component_type => value[:component_type], :value => value[:value])  
            end
        end
        
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
        
        update_params = user_profile_params.except(:location_attributes, :location_component_attributes)
        location_attributes = user_profile_params[:location_attributes]
        lat = location_attributes[:lat].to_d.round(8)
        lng = location_attributes[:lng].to_d.round(8)
        
        if Location.exists?(:lat => lat, :lng => lng)
            user_location = Location.find_by(:lat => lat, :lng => lng)
            update_params[:location_id] = user_location.id
        else
            user_location = Location.create(:lat => lat, :lng => lng)
            update_params[:location_id] = user_location.id
            
            location_components = user_profile_params[:location_component_attributes]
            location_components.each do |component, value|
               user_location.location_components.create(:component_type => value[:component_type], :value => value[:value])  
            end
        end
        
        if @user.update_attributes(update_params)
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
            params.require(:user_profile).permit(:first_name, :last_name, :birth_date, location_attributes: [:id, :lat, :lng], location_component_attributes: [:id, :component_type, :value])
        end
end
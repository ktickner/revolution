class EventsController < ApplicationController
    before_action :authenticate_user!
    before_action :event_creator?, :only => [:edit, :update, :destroy]
    before_action :profile_active?
    
    def index
        @events = Event.all
    end
    
    def new
        @event = Event.new
        @event.build_location
        @events_image = @event.events_images.build
        @image = @events_image.build_image
        @genres = Genre.all
    end
    
    def create
        @genres = Genre.all
        @event = current_user.events.build(event_params.except(:location_attributes, :location_component_attributes))
        location_attributes = event_params[:location_attributes]
        lat = location_attributes[:lat].to_d.round(8)
        lng = location_attributes[:lng].to_d.round(8)
        
        # Now I can build the locations by hand
        if Location.exists?(:lat => lat, :lng => lng)
            
            @event_location = Location.find_by(:lat => lat, :lng => lng)
            @event.location_id = @event_location.id
        else
            @event_location = Location.create(:lat => lat, :lng => lng)
            @event.location_id = @event_location.id
            
            event_components = event_params[:location_component_attributes]
            event_components.each do |component, value|
               @event_location.location_components.create(:component_type => value[:component_type], :value => value[:value])  
            end
        end
        
    
        if @event.save
            redirect_to root_url
        else
           render 'new' 
        end
    end
    
    def edit
       @event = Event.find(params[:id])
       @genres = Genre.all
    end
    
    def update
        @event = Event.find(params[:id])
        update_params = event_params.except(:location_attributes, :location_component_attributes)
        location_attributes = event_params[:location_attributes]
        lat = location_attributes[:lat].to_d.round(8)
        lng = location_attributes[:lng].to_d.round(8)
        
        if Location.exists?(:lat => lat, :lng => lng)
            event_location = Location.find_by(:lat => lat, :lng => lng)
            update_params[:location_id] = event_location.id
        else
            event_location = Location.create(:lat => lat, :lng => lng)
            update_params[:location_id] = event_location.id
            
            location_components = event_params[:location_component_attributes]
            location_components.each do |component, value|
               event_location.location_components.create(:component_type => value[:component_type], :value => value[:value])  
            end
        end
        
        if @event.update_attributes(update_params)
            redirect_to root_url
        else
            render 'edit'
        end
    end
    
    def destroy
        @event = Event.find(params[:id])
        @event.update(cancelled: true)
        redirect_to root_url
    end
    
    def remove_from_feed
        @event = Event.find(params[:id])
        @event_removal = UserRemovedEvent.where(:user_id => current_user.id, :event_id => @event.id).first_or_initialize do |event_removal|
           event_removal.user_id = current_user.id
           event_removal.event_id = @event.id
           event_removal.removed = true
        end
        @event_removal.save
        redirect_to root_url
    end
    
    private
    
        def event_creator?
           redirect_to(root_url) unless Event.find(params[:id]).creator_id == current_user.id 
        end
    
        def event_params
           params.require(:event).permit(:id, :name, :description, :over_eighteen, :private, :start_datetime, :end_datetime, events_images_attributes: [:id, :event_id, :image_id, :feature_image, image_attributes: [:id, :path]], location_attributes: [:id, :lat, :lng], location_component_attributes: [:id, :component_type, :value], :genre_ids => []) 
        end
end

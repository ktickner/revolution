class EventsController < ApplicationController
    before_action :authenticate_user!
    before_action :event_creator?, :only => [:edit, :update, :destroy]
    
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
        @event = current_user.events.build(event_params)
        
        #Needs to set location var by lat/lng attributes
        #If empty then build event as normal
        #Else build event with location_id as location.id
        
    
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
        if @event.update_attributes(event_params)
            redirect_to root
        else
          render 'edit'
        end
    end
    
    def destroy
        @event = Event.find(params[:id])
        @event.update(cancelled: true)
        redirect_to root_url
    end
    
    private
    
        def event_creator?
           redirect_to(root_url) unless Event.find(params[:id]).creator_id == current_user.id 
        end
    
        def location_attributes=(attrs)
            self.location = Location.find_or_create_by(lat: attrs[:lat], lng: attrs[:lng])
        end
    
        def event_params
           params.require(:event).permit(:name, :description, :over_eighteen, :private, :start_datetime, :end_datetime, events_images_attributes: [:feature_image, image_attributes: [:path]], location_attributes: [:id, :lat, :lng], :genre_ids => []) 
        end
end

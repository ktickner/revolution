class EventsController < ApplicationController
    before_action :authenticate_user!
    
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
        if @event.save
            redirect_to root_url
        else
           render 'new' 
        end
    end
    
    private
    
        def event_params
           params.require(:event).permit(:name, :description, :over_eighteen, :private, :start_datetime, :end_datetime, events_images_attributes: [:feature_image, image_attributes: [:path]], location_attributes: [:lat, :lng], :genre_ids => []) 
        end
end

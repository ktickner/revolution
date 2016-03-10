class EventsController < ApplicationController
    before_action :authenticate_user!
    
    def new
        @event = Event.new
        @event.build_location
        @genres = Genre.all
    end
    
    def create
        @event = current_user.events.build(event_params)
        if @event.save
            redirect_to root_url
        else
           render 'new' 
        end
    end
    
    private
    
        def event_params
           params.require(:event).permit(:name, :description, :over_eighteen, :private, :start_datetime, :end_datetime, location_attributes: [:lat, :lng], :genre_ids => []) 
        end
end

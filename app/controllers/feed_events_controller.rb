class FeedEventsController < ApplicationController
    before_action :authenticate_user!
    
    def index
        @events = FeedEvent.all
    end
end

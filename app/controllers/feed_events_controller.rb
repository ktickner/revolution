class FeedEventsController < ApplicationController
    before_action :authenticate_user!
    before_action :profile_active?
    
    def index
        @events = FeedEvent.all
    end
end

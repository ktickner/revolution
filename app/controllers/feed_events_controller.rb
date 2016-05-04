class FeedEventsController < ApplicationController
    before_action :authenticate_user!
    before_action :profile_active?
    
    def index
        @events = FeedEvent.all
        @new_comment = Comment.new
        @all_comments = Comment.all
        
        @comments = Array.new
        
        @all_comments.each do |comment, i|
            new_comment = {comment: comment.comment, event: "#{comment.event_id}", creator: "#{comment.creator.user_profile.first_name} #{comment.creator.user_profile.last_name}" } 
            @comments << new_comment
        end
    end
end

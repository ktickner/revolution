class FeedEvent < ActiveRecord::Base
   self.primary_key = "event_id"
   
   belongs_to :event
end
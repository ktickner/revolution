class UserEventResponse < ActiveRecord::Base
    self.primary_keys = :user_id, :event_id
    
    belongs_to :event_responses
    belongs_to :users
    belongs_to :events
end

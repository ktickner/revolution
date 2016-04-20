class UserRemovedEvent < ActiveRecord::Base
    self.primary_keys = :user_id, :event_id
    
    has_one :event
    has_one :user
    
    validates :removed, presence: true
end

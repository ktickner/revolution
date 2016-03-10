class EventLog < ActiveRecord::Base
    
    # Model associations
    belongs_to :user
    belongs_to :event
    
    # ActiveRecord validations
    validates :description, presence: true, length: { minimum: 1 }
end

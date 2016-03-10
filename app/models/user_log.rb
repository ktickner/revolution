class UserLog < ActiveRecord::Base
    
    # Model associations
    belongs_to :user
    
    # ActiveRecord validations
    validates :description, presence: true, length: { minimum: 1 }
end

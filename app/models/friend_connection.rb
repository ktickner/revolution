class FriendConnection < ActiveRecord::Base
    
    # Sets composite primary key
    self.primary_keys = :user_id, :friend_id
    
    # Model associations
    belongs_to :user
    belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
    
    # Activerecord Validations
end

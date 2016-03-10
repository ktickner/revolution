class UserProfileImage < ActiveRecord::Base
    
    # Sets composite primary key
    self.primary_keys = :user_id, :image_id
    
    # Model associations
    belongs_to :user
    belongs_to :image
    
    # Activerecord validations
end

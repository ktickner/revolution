class Comment < ActiveRecord::Base
    
    #Model Associations
    belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
    belongs_to :event
    
    validates :comment, presence: true
end

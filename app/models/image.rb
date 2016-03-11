class Image < ActiveRecord::Base
    
    # Model associations
    belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
    has_many :events, through: :events_images
    has_many :events_images
    
    # ActiveRecord validations
    validates :path, presence: true
end

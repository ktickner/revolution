class EventsImage < ActiveRecord::Base
    
    # Model Associations
    belongs_to :event
    belongs_to :image
    accepts_nested_attributes_for :image
    
    # ActiveRecord validations
    validates :feature_image, presence: true
end

class Location < ActiveRecord::Base
    
    # Model associations
    has_many :user_profiles
    has_many :location_components
    has_many :events
    
    # ActiveRecord validation
    validates :lat, presence: true, numericality: true, length: { maximum: 12 }
    validates :lng, presence: true, numericality: true, length: { maximum: 13 }
end

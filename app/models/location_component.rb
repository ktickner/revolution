class LocationComponent < ActiveRecord::Base
    
    # Model associations
    belongs_to :location
    has_many :events, through: :location
    
    # Activerecord validations
    validates :component_type, presence: true, length: { minimum: 1, maximum: 50 }
    validates :value, presence: true, length: { minimum: 1, maximum: 100 }
end

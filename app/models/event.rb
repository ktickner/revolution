class Event < ActiveRecord::Base
    
    # Model associations
    belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
    belongs_to :location
    accepts_nested_attributes_for :location
    has_many :location_components, through: :location
    accepts_nested_attributes_for :location_components
    has_and_belongs_to_many :genres, :association_foreign_key => "genre_name"
    has_many :events_images
    accepts_nested_attributes_for :events_images
    has_many :images, through: :events_images
    has_many :user_removed_events
    
    has_one :feed_event
    
    # ActiveRecord validations
    validates :name, presence: true, length: { minimum: 1, maximum: 255 }
    validates :description, presence: true, length: { minimum: 1 }
    validates :start_datetime, presence: true
    validates_datetime :start_datetime, :after => :now
    validates_datetime :end_datetime, :after => :start_datetime
end

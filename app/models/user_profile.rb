class UserProfile < ActiveRecord::Base
  
  # Setting domain specific primary key
  self.primary_key = 'user_id'
  
  # Model associations
  belongs_to :user
  belongs_to :location
  accepts_nested_attributes_for :location
  
  # ActiveRecord Validations
    validates :first_name, presence: true, length: { minimum: 1, maximum: 255 }
    validates :last_name, presence: true, length: { minimum: 1, maximum: 255 }
    validates :birth_date, presence: true
    validates_datetime :birth_date, :before => :now
    validates_datetime :birth_date, :after => lambda { 150.years.ago }
end

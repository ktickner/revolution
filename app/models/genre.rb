class Genre < ActiveRecord::Base
    # Setting domain specific primary key
  self.primary_key = :name
  
    # Model Associations
    has_and_belongs_to_many :users, :foreign_key => "genre_name"
    has_and_belongs_to_many :events, :foreign_key => "genre_name"
    belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  
    # ActiveRecord validations
    
    
end

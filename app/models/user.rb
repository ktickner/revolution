class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
         
  # Model associations
  
    #UserProfile
  has_one :user_profile
  
    #Location
  has_one :location, :through => :user_profiles
  has_many :location_components, :through => :locations
  
    # FriendConnection
  has_many :friend_connections
  has_many :friends, :through => :friend_connections
  has_many :inverse_friend_connections, :class_name => "FriendConnection", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friend_connections, :source => :user
  
    # UserLog
  has_many :user_logs
  
    # Image
  has_many :images, :foreign_key => "creator_id"
  
    # UserProfileImage
  has_many :user_profile_images
  
    # Event
  has_many :events, :foreign_key => "creator_id"
  has_many :user_removed_events
    
    #EventLog
  has_many :event_logs
  
    #Genre
  has_and_belongs_to_many :genres, :association_foreign_key => "genre_name"
  has_many :genres, :foreign_key => "creator_id"
  
end

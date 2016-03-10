class Image < ActiveRecord::Base
    
    # Model associations
    belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
end

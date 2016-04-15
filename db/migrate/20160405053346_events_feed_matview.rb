class EventsFeedMatview < ActiveRecord::Migration
  def up
    execute <<-SQL
    	CREATE VIEW feed_events AS
      	SELECT
      	  e.id AS event_id,
      		e.name AS event_name,
      		e.creator_id AS creator_id,
      		e.description AS event_description,
      		e.over_eighteen AS over_eighteen,
      		e.private AS private,
      		e.start_datetime AS event_start,
      		e.end_datetime AS event_end,
      		i.path AS feature_image_path,
      		l.lat AS event_lat,
      		l.lng AS event_lng,
      		up.first_name AS creator_first_name,
      		up.last_name AS creator_last_name
    	FROM events e
    	LEFT JOIN events_images ei ON e.id = ei.event_id AND ei.feature_image = TRUE
    	LEFT JOIN images i ON ei.image_id = i.id AND i.removed = FALSE
    	LEFT JOIN locations l ON e.location_id = l.id
    	LEFT JOIN user_profiles up ON e.creator_id = up.user_id
    	WHERE e.start_datetime > now()
    SQL
  end
  
  def down
    execute "DROP VIEW feed_events"
  end
end

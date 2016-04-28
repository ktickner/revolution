class ChangeEventsFeedView < ActiveRecord::Migration
  def up
    execute <<-SQL
    	CREATE OR REPLACE VIEW feed_events AS
      	SELECT DISTINCT ON(e.id)
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
      		lc.value AS event_address,
      		up.first_name AS creator_first_name,
      		up.last_name AS creator_last_name,
      		ur.response_id AS user_response,
      		g.genre_name AS event_genre
    	FROM events e
    	LEFT JOIN events_images ei ON e.id = ei.event_id AND ei.feature_image = TRUE
    	LEFT JOIN images i ON ei.image_id = i.id AND i.removed = FALSE
    	LEFT JOIN locations l ON e.location_id = l.id
    	LEFT JOIN location_components lc ON lc.location_id = l.id AND lc.component_type = 'formatted_address'
    	LEFT JOIN user_profiles up ON e.creator_id = up.user_id
    	LEFT JOIN events_genres g ON g.event_id = e.id
    	LEFT JOIN user_event_responses ur ON ur.event_id = e.id
    	WHERE e.start_datetime > now() AND e.cancelled = FALSE
    SQL
  end
  
  def down
    execute "DROP VIEW feed_events"
  end
end

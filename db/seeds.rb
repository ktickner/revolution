# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#event_responses = EventResponse.create([{ response: 'none' }, { response: 'going' }, { response: 'interested' }, { response: 'removed' }])
genres = Genre.create([{ name: 'Death Metal', creator_id: 3}, { name: 'Thrash Metal', creator_id: 3}, { name: 'Traditional Metal', creator_id: 3}, { name: 'Black Metal', creator_id: 3}, { name: 'Power Metal', creator_id: 3}, { name: 'Progressive Metal', creator_id: 3}, ])
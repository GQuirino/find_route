# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Map.destroy_all
Distance.destroy_all

map = Map.create!(
  name: 'map1'
)

map.distances.create!([{ origin: 'A',
                         destiny: 'B',
                         distance: 10 },
                       { origin: 'A',
                         destiny: 'C',
                         distance: 20 },
                       { origin: 'C',
                         destiny: 'D',
                         distance: 30 },
                       { origin: 'B',
                         destiny: 'D',
                         distance: 15 },
                       { origin: 'B',
                         destiny: 'E',
                         distance: 50 },
                       { origin: 'D',
                         destiny: 'E',
                         distance: 30 }])

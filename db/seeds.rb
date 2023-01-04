# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# The current conversion process

# Get pt_golfer_production db from backups stored on macmini, unzip it

# cd to pt_golfer 
# bin/rails db:drop  --probably have to set env vairable
# bin/rails db:create

# psql -d pt_golfer_development < pt_golfer_production.sql

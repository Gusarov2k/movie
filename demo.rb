# frozen_string_literal: true

require_relative 'movie'
require_relative 'movie_collection'
require 'pry'

file_name = ARGV[0] || 'movies.txt'

movies = MovieCollection.new(file_name)
movies.sort_by(:release_date)

# movies.filter(country: 'USA', year: 2001..2002, runtime: 92)
movies.filter(film_director: /pola/i)
movies.stats(:genres)
movie = movies.all.first

movie.genre?('Drama')

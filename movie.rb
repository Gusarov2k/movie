# frozen_string_literal: true

require 'date'
require 'csv'
require 'ostruct'

input_arg = ARGV[1]

if input_arg.nil?
  file_name = 'movies.csv'
elsif File.file? input_arg
  file_name = input_arg
else
  abort 'Your file don\'t find try to again'
end

keys = %i[link
          original_title
          year
          country
          release_date
          genres
          runtime
          popularity
          film_director
          stars]

base_movies = CSV.read(file_name, col_sep: '|', converters: %i[date integer float])

base_movies.map! { |row| keys.zip(row).to_h }

base = OpenStruct.new(movies: base_movies)

def films_review(movies, title)
  puts "#{title}:"
  movies.each do |movie|
    puts "#{movie[:original_title]} (#{movie[:release_date].strftime('%d - %B - %Y')} " \
         "#{movie[:genres]}) - #{movie[:runtime]}"
  end
  puts '*' * 70
end

max_runtime = base.movies.sort_by { |movie| movie[:runtime].to_i }
films_review(max_runtime.last(5), '5 films with max runtime')

# binding.pry
fils = base.movies.sort_by { |movie| movie[:release_date].to_i if movie[:release_date].eql? Date }
comedy = []
fils.each { |movie| comedy.push(movie) if movie[:genres].include?('Comedy') }
films_review(comedy.first(10), '10 first comedy to ASC')

directors = (base.movies.sort_by do |movie|
               movie[:film_director].split.last
             end).uniq { |movie| movie[:film_director] }

directors.each { |movie| puts movie[:film_director] }

puts "#{base.movies.select { |movie| movie[:country].include?('USA') }.count} movies not made in USA"

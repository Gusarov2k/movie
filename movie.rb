# frozen_string_literal: true
require 'csv'

input_arg = ARGV[1]

if input_arg.nil?
  file_name = 'movies.csv'
elsif File.file? input_arg
  file_name = input_arg
else
  abort 'Your file don\'t find try to again'
end

movies = CSV.read(file_name, col_sep: '|')

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

movies.map! { |row| keys.zip(row).to_h }
binding.pry
def films_review(movies, title)
  puts "#{title}:"
  movies.each do |movie|
    puts "#{movie[:original_title]} (#{movie[:release_date]};" \
         "#{movie[:genres]}) - #{movie[:runtime]}"
  end
  puts '*' * 70
end

max_runtime = movies.sort_by { |movie| movie[:runtime].to_i }
films_review(max_runtime.last(5), '5 films with max runtime')

film_release_date = movies.sort_by { |movie| movie[:release_date].split('-') }
comedy = []
film_release_date.each { |movie| comedy.push(movie) if movie[:genres].include?('Comedy') }
films_review(comedy.first(10), '10 first comedy to ASC')

directors = (movies.sort_by do |movie|
               movie[:film_director].split.last
             end).uniq { |movie| movie[:film_director] }

directors.each { |movie| puts movie[:film_director] }

puts "#{movies.select { |movie| movie[:country].include?('USA') }.count} movies not made in USA"

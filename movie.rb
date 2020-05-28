# frozen_string_literal: true

require 'date'
require 'csv'
require 'ostruct'

input_arg = ARGV[1]

if input_arg.nil?
  file_name = 'movies.txt'
elsif File.file? input_arg
  file_name = input_arg
else
  abort 'Your file don\'t find try to again'
end

base_movies = CSV.read(file_name, col_sep: '|',
                                  headers: %i[link original_title year country release_date
                                              genres runtime popularity film_director stars],
                                  converters: %i[date integer float])
                 .map { |row| OpenStruct.new(row.to_hash) }

def films_review(movies, title)
  puts "#{title}:"
  movies.each do |movie|
    puts "#{movie.original_title} (#{movie.release_date.strftime('%d - %B - %Y')} " \
         "#{movie.genres}) - #{movie.runtime}"
  end
  puts '*' * 70
end

max_runtime = base_movies.sort_by { |movie| movie.runtime.to_i }

films_review(max_runtime.last(5), '5 films with max runtime')

films = base_movies.select { |movie| movie.release_date.is_a? Date }
films = films.sort_by(&:release_date)

comedy = films.select { |movie| movie.genres.include?('Comedy') }
films_review(comedy.first(10), '10 first comedy to ASC')

directors = base_movies.map(&:film_director).uniq.sort_by { |name| name.split.last }

puts directors

puts "#{base_movies.count { |movie| movie.country.include?('USA') }} movies not made in USA"

month_statistic = films.group_by { |movie| movie.release_date.strftime('%B').to_sym }.transform_values(&:count)
                       .sort_by(&:last)

month_statistic.each { |month, key| puts "#{month} - #{key}" }

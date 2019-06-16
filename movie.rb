# frozen_string_literal: true

require 'date'

class Movie
  attr_accessor :link, :original_title, :year, :country, :release_date, :genres, :runtime, :popularity, :film_director,
                :stars

  def initialize(collection, link:, original_title:, year:, country:, release_date:, genres:, runtime:,
                 popularity:, film_director:, stars:)
    @link = link
    @original_title = original_title
    @year = year.to_i
    @country = country
    @release_date = if release_date.is_a? Date
                      release_date
                    elsif release_date.is_a? String
                      Date.parse(release_date + '-01')
                    elsif release_date.is_a? Integer
                      Date.new(release_date)
                    end
    @genres = genres.split(',')
    @runtime = runtime.to_i
    @popularity = popularity.to_f
    @film_director = film_director
    @stars = stars.split(',')
    @all_movies = collection
  end

  def genre?(param)
    raise 'genre not find' unless @all_movies.genre_exist?(param)

    genres.include?(param)
  end

  def match_filter?(name, value)
    if send(name).is_a?(Array)
      send(name).any? { |i| value === i }
    else
      value === send(name)
    end
  end
end

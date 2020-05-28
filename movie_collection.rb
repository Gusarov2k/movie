# frozen_string_literal: true

require 'date'
require 'csv'

class MovieCollection
  attr_accessor :movies

  HEADERS_KEYS = %i[link original_title year country release_date genres runtime popularity film_director stars].freeze
  CONVERTERS_KEYS = %i[date integer float].freeze

  def initialize(file_name)
    @movies = CSV.read(file_name, col_sep: '|',
                                  headers: HEADERS_KEYS,
                                  converters: CONVERTERS_KEYS).map { |row| Movie.new(self, row.to_h) }
  end

  def all
    movies
  end

  def sort_by(param)
    movies.sort_by(&param)
  end

  def filter(parameters)
    parameters.reduce(@movies) { |movie, (key, value)| movie.select { |m| m.match_filter?(key, value) } }
  end

  def stats(param)
    movies.flat_map(&param).group_by(&:itself).transform_values(&:count).sort_by(&:last)
  end

  def existing_genres
    @existing_genres ||= @movies.flat_map(&:genres).uniq
  end

  def genre_exist?(genre)
    existing_genres.include?(genre)
  end
end

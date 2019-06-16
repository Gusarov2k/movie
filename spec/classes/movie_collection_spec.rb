# frozen_string_literal: true

require_relative '../../movie'
require_relative '../../movie_collection'

RSpec.describe MovieCollection do
  let(:file_name) { './spec/fixtures/movies.txt' }
  let(:movie_collection) { described_class.new(file_name) }
  let(:params) do
    {
      link: 'http://imdb.com/title/tt0111161/?ref_=chttp_tt_1', original_title: 'The Shawshank Redemption', year: 1994,
      country: 'USA', release_date: Date.new(1994, 10, 14), genres: %w[Crime Drama], runtime: 142, popularity: 9.3,
      film_director: 'Frank Darabont', stars: ['Tim Robbins', 'Morgan Freeman', 'Bob Gunton']
    }
  end

  describe '.new' do
    subject(:new) { described_class.new(file_name) }

    context 'when true' do
      let(:file_name) { './spec/fixtures/one_movie.txt' }

      it { is_expected.to be_an_instance_of(described_class) }
    end

    context 'when file not exists' do
      let(:file_name) { './not_exists_file.txt' }

      it { expect { new }.to raise_error(Errno::ENOENT) }
    end
  end

  describe '#all' do
    subject(:movies) { movie_collection.all }

    context 'when file select movies' do
      let(:file_name) { './spec/fixtures/one_movie.txt' }
      let(:params) do
        {
          link: 'http://imdb.com/title/tt0111161/?ref_=chttp_tt_1', original_title: 'The Shawshank Redemption',
          year: 1994, country: 'USA', release_date: Date.new(1994, 10, 14), genres: %w[Crime Drama], runtime: 142,
          popularity: 9.3, film_director: 'Frank Darabont', stars: ['Tim Robbins', 'Morgan Freeman', 'Bob Gunton']
        }
      end

      it { is_expected.to be_an(Array).and all be_an(Movie) }

      it 'return movie instance with data from file' do
        expect(movies.first).to have_attributes(params)
      end
    end

    context 'when file is empty' do
      let(:file_name) { './spec/fixtures/empty.txt' }

      it { is_expected.to eq [] }
    end
  end

  describe '#genre_exist?' do
    subject { movie_collection.genre_exist?(genre) }

    let(:genre) { 'Drama' }

    context 'when exist' do
      it { is_expected.to be_truthy }
    end

    context 'when not exist' do
      let(:genre) { 'wDrama' }

      it { is_expected.not_to be_truthy }
    end
  end

  describe '#stats' do
    subject(:movies_stats) { movie_collection.stats(stats) }

    let(:stats) { :genres }

    context 'when stats genres' do
      it 'return genres' do
        expect(movies_stats).to include('Action' => 1, 'Crime' => 5, 'Drama' => 5)
      end
    end

    context 'when stats film_director' do
      let(:stats) { :film_director }

      it 'return film_directors' do
        expect(movies_stats).to include('Frank Darabont' => 1, 'Christopher Nolan' => 1, 'Sidney Lumet' => 1,
                                        'Francis Ford Coppola' => 2)
      end
    end

    context 'when invalid params' do
      let(:stats) { :film }

      it { expect { movies_stats }.to raise_error(RuntimeError, 'invalid keys') }
    end
  end

  describe '#sort_by' do
    subject(:movies_stats) { movie_collection.sort_by(sorting) }

    context 'when sorting by year' do
      let(:sorting) { :year }

      it { expect(movies_stats.map(&:year)).to contain_exactly(1957, 1972, 1974, 1994, 2008) }
    end
  end

  describe '#filter' do
    subject(:film_collection) { movie_collection.filter(filters) }

    context 'when filter by years' do
      let(:filters) { { year: 1957..1974 } }

      it { expect(film_collection).to all have_attributes(year: 1957..1974) }
    end

    context 'when filter by film_director' do
      let(:filters) { { film_director: /rank/i } }

      it 'there is a word in the name' do
        expect(film_collection).to all have_attributes(film_director: 'Frank Darabont')
      end
    end

    context 'when filter by country, year and runtime' do
      let(:filters) { { genres: 'Action', year: 2008 } }

      it 'genres exists' do
        expect(film_collection).to all have_attributes(genres: %w[Action Crime Drama])
      end

      it 'year exists' do
        expect(film_collection).to include have_attributes(year: 2008)
      end
    end
  end
end

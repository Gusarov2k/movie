# frozen_string_literal: true

require_relative '../../movie'
require_relative '../../movie_collection'
require 'pry'

describe Movie do
  let(:collection) { instance_double('MovieCollection', existing_genres: %w[Comedy Drama]) }
  let(:release_date) { '1900-01' }
  let(:params) do
    { link: 'link', original_title: 'original_title', year: '1900', country: 'DAN', release_date: release_date,
      genres: 'Comedy,Drama', runtime: '120 min', popularity: '9.2', film_director: 'brothers wachowski',
      stars: 'Keanu Reeves,Laurence Fishburne' }
  end
  let(:movie) { described_class.new(collection, params) }

  it 'check initialize value' do
    expect(movie.release_date.to_s).to eq '1900-01-01'
    expect(movie).to have_attributes(link: 'link', original_title: 'original_title', year: 1900, country: 'DAN',
                                     genres: (include 'Comedy', 'Drama'), runtime: 120, popularity: 9.2,
                                     film_director: 'brothers wachowski',
                                     stars: (include 'Keanu Reeves', 'Laurence Fishburne'))
  end

  context 'when release_date only year' do
    let(:release_date) { 1900 }
    let(:movie) { described_class.new(collection, params) }

    it { expect(movie.release_date.to_s).to eq '1900-01-01' }
  end

  describe '#genre?' do
    subject(:film) { movie.genre?(genre) }

    let(:result) { true }

    before do
      allow(collection)
        .to receive(:genre_exist?)
        .with(genre)
        .and_return(result)
    end

    context 'when true' do
      let(:genre) { 'Comedy' }

      it { expect(film).to be_truthy }
    end

    context 'when genre not exist' do
      let(:genre) { 'not_genre' }
      let(:result) { false }

      it { expect { film.genre?(genre) }.to raise_error(RuntimeError, 'genre not find') }
    end
  end
end

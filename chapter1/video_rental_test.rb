require "minitest"
require "minitest/autorun"
require "minitest/spec"
require "minitest/pride"
require_relative "video_rental"

describe Rental do
  it "remembers a movie" do
    rental = Rental.new(:movie, 5)
    rental.movie.must_equal :movie
  end

  it "remembers the number of days" do
    rental = Rental.new(:movie, 5)
    rental.days_rented.must_equal 5
  end
end

describe Movie do
  let(:regular) { Movie::REGULAR }
  let(:new_release) { Movie::NEW_RELEASE }

  it "has constants for price codes" do
    Movie::REGULAR.must_equal 0
    Movie::NEW_RELEASE.must_equal 1
    Movie::CHILDRENS.must_equal 2
  end

  it "has a title" do
    movie = Movie.new "Alien", regular
    movie.title.must_equal "Alien"
  end

  it "has a price code" do
    movie = Movie.new "Alien", regular
    movie.price_code.must_equal regular
  end

  it "allows changing the price code" do
    movie = Movie.new "Alien", new_release
    movie.price_code = regular
    movie.price_code.must_equal regular
  end

  it "does not allow changing the title" do
    movie = Movie.new "Alien", regular
    proc {movie.title = "x"}.must_raise NoMethodError
  end
end

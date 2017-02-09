require "minitest"
require "minitest/autorun"
require "minitest/spec"
require "minitest/pride"
require_relative "video_rental"

describe Rental do
  it "remembers a movie and a number of days" do
    rental = Rental.new(:movie, 5)
    rental.movie.must_equal :movie
    rental.days_rented.must_equal 5
  end
end

describe Movie do
  it "has constants for price codes" do
    Movie::REGULAR.must_equal 0
    Movie::NEW_RELEASE.must_equal 1
    Movie::CHILDRENS.must_equal 2
  end

  it "has a title and a price code" do
    movie = Movie.new "Alien", 2
    movie.title.must_equal "Alien"
    movie.price_code.must_equal 2
  end

  it "allows changing the price code, but not the title" do
    movie = Movie.new "Alien", 2
    movie.price_code = :new_price_code
    movie.price_code.must_equal :new_price_code
    proc {movie.title = "x"}.must_raise NoMethodError
  end
end

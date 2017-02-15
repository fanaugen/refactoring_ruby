require "minitest"
require "minitest/autorun"
require "minitest/spec"
require "minitest/pride"
require_relative "video_rental"

describe Customer do
  subject { Customer.new("Smith") }
  it "has a name" do
    subject.name.must_equal "Smith"
  end

  it "keeps a record of rentals" do
    subject.add_rental Rental.new(:movie1, 2)
    subject.add_rental Rental.new(:movie2, 7)

    subject.rentals.length.must_equal 2
    subject.rentals[0].movie.must_equal :movie1
    subject.rentals[1].movie.must_equal :movie2
  end

  describe "#statement" do
    let(:regular_movie)   { Movie.new("Regent", Movie::REGULAR) }
    let(:new_movie)       { Movie.new("Newton", Movie::NEW_RELEASE) }
    let(:childrens_movie) { Movie.new("Chills", Movie::CHILDRENS) }

    it "outputs a String" do
      subject.statement.must_be_instance_of String
    end

    it "includes a header line with the customer’s name" do
      subject.statement.must_include "Rental Record for Smith"
    end

    describe "rental costs for 1 day" do
      before do
        subject.add_rental(Rental.new(regular_movie, 1))
        subject.add_rental(Rental.new(new_movie, 1))
        subject.add_rental(Rental.new(childrens_movie, 1))
      end

      it "includes movie title and fee for each rented movie" do
        s = subject.statement
        s.must_match /^\tRegent\t2$/
        s.must_match /^\tNewton\t3$/
        s.must_match /^\tChills\t1\.5$/
      end

      it "includes the total fee for all rentals" do
        subject.statement.must_include "Amount owed is 6.5"
      end

      it "includes frequent renter points earned" do
        subject.statement.must_include "You earned 3 frequent renter points"
      end
    end

    describe "frequent renter points" do
      it "bonus point for each new release movie rented for 2 or more days" do
        subject.add_rental(Rental.new(new_movie, 1))
        subject.add_rental(Rental.new(new_movie, 2)) # <-- bonus point
        subject.add_rental(Rental.new(regular_movie, 3))
        subject.statement.must_include "You earned 4 frequent renter points"
      end
    end

    describe "regular movie, more than two days" do
      it "costs 2 dollars plus 1.5 dollars for each additional day" do
        subject.add_rental(Rental.new(regular_movie, 4))
        subject.statement.must_match /^\tRegent\t#{2 + 1.5 * 2}$/
      end
    end

    describe "childrens movie, more than three days" do
      it "costs 1.5 dollars plus 1.5 dollars for each additional day" do
        subject.add_rental(Rental.new(childrens_movie, 6))
        subject.statement.must_match /^\tChills\t#{1.5 + 1.5 * 3}$/
      end
    end

    describe "complete example with different numbers" do
      it "prints the statement as expected" do
        rent = ->(m, d) { subject.add_rental Rental.new(m, d) }
        #                          fee     points
        # =======================================
        rent[regular_movie, 2]   # 2       1
        rent[regular_movie, 3]   # 3.5     1
        rent[new_movie, 1]       # 3       1
        rent[new_movie, 3]       # 9       2
        rent[childrens_movie, 3] # 1.5     1
        rent[childrens_movie, 4] # 3       1
        # =======================================
        #              total:      22.0    7

        subject.statement.must_equal <<~STATEMENT
          Rental Record for Smith
          \tRegent\t2
          \tRegent\t3.5
          \tNewton\t3
          \tNewton\t9
          \tChills\t1.5
          \tChills\t3.0
          Amount owed is 22.0
          You earned 7 frequent renter points
        STATEMENT
        .chomp
      end
    end
  end
end

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

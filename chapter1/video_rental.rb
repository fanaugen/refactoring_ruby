class Customer
  attr_reader :name, :rentals

  def initialize(name)
    @name = name
    @rentals = []
  end

  def statement
    result = ["Rental Record for #{name}"]
    frequent_renter_points = 0

    rentals.each do |rental|
      frequent_renter_points += rental.frequent_renter_points

      result << "\t#{rental.movie.title}\t#{rental.charge}"
    end

    # footer: summary
    result << "Amount owed is #{total_charge}"
    result << "You earned #{total_points} frequent renter points"
    result.join("\n")
  end

  def total_points
    frequent_renter_points = 0
    rentals.each do |rental|
      frequent_renter_points += rental.frequent_renter_points
    end
    frequent_renter_points
  end

  def total_charge
    rentals.sum { |rental| rental.charge }
  end

  def add_rental(rental)
    @rentals << rental
  end
end

class Movie
  REGULAR     = 0
  NEW_RELEASE = 1
  CHILDRENS   = 2

  attr_reader   :title
  attr_accessor :price_code

  def initialize(title, price_code)
    @title, @price_code = title, price_code
  end

end

class Rental
  attr_reader :movie, :days_rented

  def initialize(movie, days_rented)
    @movie, @days_rented = movie, days_rented
  end

  def charge
    amount = 0
    case movie.price_code
    when Movie::REGULAR
      amount += 2
      amount += 1.5 * (days_rented - 2) if days_rented > 2
    when Movie::NEW_RELEASE
      amount += 3 * days_rented
    when Movie::CHILDRENS
      amount += 1.5
      amount += 1.5 * (days_rented - 3) if days_rented > 3
    end
    amount
  end

  def frequent_renter_points
    if movie.price_code == Movie::NEW_RELEASE && days_rented > 1
      2
    else
      1
    end
  end

end

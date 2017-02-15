class Customer
  attr_reader :name, :rentals

  def initialize(name)
    @name = name
    @rentals = []
  end

  def statement
    result = ["Rental Record for #{name}"]
    total_amount = frequent_renter_points = 0

    rentals.each do |rental|
      frequent_renter_points += frequent_renter_points_for(rental)

      result << "\t#{rental.movie.title}\t#{rental.charge}"
      total_amount += rental.charge
    end

    # footer: summary
    result << "Amount owed is #{total_amount}"
    result << "You earned #{frequent_renter_points} frequent renter points"
    result.join("\n")
  end

  def frequent_renter_points_for(rental, frequent_renter_points = 0)
    rental.frequent_renter_points_for # execute, don’t use
    frequent_renter_points += 1
    if rental.movie.price_code == Movie::NEW_RELEASE && rental.days_rented > 1
      frequent_renter_points += 1
    end
    frequent_renter_points
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

  def frequent_renter_points_for(rental = self, frequent_renter_points = 0)
    frequent_renter_points += 1
    if rental.movie.price_code == Movie::NEW_RELEASE && rental.days_rented > 1
      frequent_renter_points += 1
    end
    frequent_renter_points
  end

end

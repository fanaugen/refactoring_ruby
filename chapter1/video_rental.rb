class Customer
  attr_reader :name, :rentals

  def initialize(name)
    @name = name
    @rentals = []
  end

  def statement
    result = ["Rental Record for #{name}"]

    rentals.each do |rental|
      result << "\t#{rental.movie.title}\t#{rental.charge}"
    end

    # footer: summary
    result << "Amount owed is #{total_charge}"
    result << "You earned #{total_points} frequent renter points"
    result.join("\n")
  end

  def html_statement
    result = ["<h1>Rentals for <em>#{name}</em></h1>"]

    result << "<p><ul>"
    rentals.each do |rental|
      result << "<li>#{rental.movie.title}: #{rental.charge}</li>"
    end
    result << "</ul></p>"

    # add summary
    result << "<p>You owe <em>#{total_charge}</em></p>"
    result << "<p>Congratulations, you earned <em>#{total_points} " +
      "frequent renter points!</em></p>"

    result.join("\n")
  end

  def add_rental(rental)
    @rentals << rental
  end

  private

  def total_points
    rentals.sum { |rental| rental.frequent_renter_points }
  end

  def total_charge
    rentals.sum { |rental| rental.charge }
  end
end

class Movie
  REGULAR     = 0
  NEW_RELEASE = 1
  CHILDRENS   = 2

  attr_reader :title, :price_code, :price

  def initialize(title, the_price_code)
    @title = title
    self.price_code = the_price_code
  end

  def price_code=(value)
    @price_code = value
    @price = case price_code
             when REGULAR     then RegularPrice.new
             when NEW_RELEASE then NewReleasePrice.new
             when CHILDRENS   then ChildrensPrice.new
             end
  end

  class RegularPrice
    def charge(days_rented)
      if days_rented > 2
        2 + 1.5 * (days_rented - 2)
      else
        2
      end
    end
  end

  class NewReleasePrice
    def charge(days_rented)
      3 * days_rented
    end
  end

  class ChildrensPrice
  end

  def charge(days_rented)
    case price_code
    when REGULAR
      price.charge(days_rented)

    when NEW_RELEASE
      price.charge(days_rented)

    when CHILDRENS
      if days_rented > 3
        1.5 + 1.5 * (days_rented - 3)
      else
        1.5
      end
    end
  end

  def frequent_renter_points(days_rented)
    case price_code
    when NEW_RELEASE
      if days_rented > 1
        2
      else
        1
      end
    else
      1
    end
  end
end

class Rental
  attr_reader :movie, :days_rented

  def initialize(movie, days_rented)
    @movie, @days_rented = movie, days_rented
  end

  def charge
    movie.charge(days_rented)
  end

  def frequent_renter_points
    movie.frequent_renter_points(days_rented)
  end
end

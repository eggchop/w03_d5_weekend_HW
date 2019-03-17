require_relative('../db/sql_runner.rb')
require_relative('./film')

class Customer
  attr_reader :id
  attr_accessor :name, :funds
  def initialize(options={})
    @name = options['name']
    @funds = options['funds']
    @id = options['id'] if options['id']
  end

  def self.delete_all
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def save
    sql = "INSERT INTO customers (name, funds) VALUES ($1,$2) RETURNING id"
    values = [@name,@funds]
    @id = SqlRunner.run(sql,values).first['id']
  end

  def self.all
    sql = "SELECT * FROM customers"
    customers_array = SqlRunner.run(sql)
    return customers_array.map{|customer| Customer.new(customer)}
  end

  def update
    sql = "UPDATE customers SET (name,funds) = ($1,$2) WHERE id = $3"
    values = [@name,@funds,@id]
    SqlRunner.run(sql,values)
  end

  def delete
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql,values)
  end

  def films
    sql = "SELECT *
          FROM customers
          JOIN tickets
          ON customers.id = tickets.customer_id
          JOIN films
          ON films.id = tickets.film_id
          WHERE customer_id = $1"
    values = [@id]
    film_array = SqlRunner.run(sql,values)
    return film_array.map{|film| Film.new(film)}
  end

  #Basic Extention + Updated for Advanced Extension
  def buy_ticket(film,screening)
    return 'Sorry, that screening is fully sold out.' if !screening.tickets_available?
    return 'You do not have sufficient funds' if @funds > film.get_film_price
    screening.sell_ticket
    change_funds(-film.get_film_price)
    new_ticket = Ticket.new({'customer_id' => @id,'film_id' => film.get_id,'screening_id'=>screening.id})
    new_ticket.save
  end

  def change_funds(amount)
    @funds += amount
    self.update
  end

  def ticket_count
    return self.films.count
  end

end

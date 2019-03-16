require_relative('../db/sql_runner.rb')

class Film
  attr_reader :id
  attr_accessor :title, :price
  def initialize(options={})
    @title = options['title']
    @price = options['price']
    @id = options['id'] if options['id']
  end

  def self.delete_all
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def save
    sql = "INSERT INTO films (title, price) VALUES ($1,$2) RETURNING id"
    values = [@title,@price]
    @id = SqlRunner.run(sql,values).first['id']
  end

  def self.all
    sql = "SELECT * FROM films"
    film_array = SqlRunner.run(sql)
    return film_array.map{|film| Film.new(film)}
  end

  def update
    sql = "UPDATE films SET (title,price) = ($1,$2) WHERE id = $3"
    values = [@title,@price,@id]
    SqlRunner.run(sql,values)
  end

  def delete
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql,values)
  end

  def customers
    sql = "SELECT *
          FROM customers
          JOIN tickets
          ON customers.id = tickets.customer_id
          JOIN films
          ON films.id = tickets.film_id
          WHERE film_id = $1"
    values = [@id]
    customer_array = SqlRunner.run(sql,values)
    return customer_array.map{|customer| Customer.new(customer)}
  end
end

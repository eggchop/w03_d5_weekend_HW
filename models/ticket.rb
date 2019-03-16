require_relative('../db/sql_runner.rb')

class Ticket
  attr_reader :id
  attr_accessor :customer_id, :film_id
  def initialize(options={})
    @id = options['id'] if options['id']
    @customer_id = options['customer_id']
    @film_id = options['film_id']

  end

  def self.delete_all
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def save
    sql = "INSERT INTO tickets (customer_id, film_id) VALUES ($1,$2) RETURNING id"
    values = [@customer_id,@film_id]
    @id = SqlRunner.run(sql,values).first['id']
  end

  def self.all
    sql = "SELECT * FROM tickets"
    ticket_array = SqlRunner.run(sql)
    return ticket_array.map{|ticket| Ticket.new(ticket)}
  end

  # How does this work with foreign key contraint?
  def update
    sql = "UPDATE tickets SET (customer_id,film_id) = ($1,$2) WHERE id = $3"
    values = [@customer_id,@film_id,@id]
    SqlRunner.run(sql,values)
  end

  def delete
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql,values)
  end

end

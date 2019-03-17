require_relative('../db/sql_runner.rb')

class Screening
  attr_reader :id
  attr_accessor :start_time, :ticket_number
  def initialize(options={})
    @id = options['id'] if options['id']
    @start_time = options['start_time']
    @ticket_number = options['ticket_number']
  end

  def self.delete_all
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def save
    sql = "INSERT INTO screenings (start_time,ticket_number) VALUES ($1,$2) RETURNING id"
  values = [@start_time,@ticket_number]
    @id = SqlRunner.run(sql,values).first['id']
  end

  def self.all
    sql = "SELECT * FROM screenings"
    screenings_array = SqlRunner.run(sql)
    return screenings_array.map{|screening| Screening.new(screening)}
  end

  def update
    sql = "UPDATE screenings SET start_time=$1, @ticket_number=$2 WHERE id = $3"
    values = [@start_time,@ticket_number,@id]
    SqlRunner.run(sql,values)
  end

  def delete
    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql,values)
  end

  #Advanced Extensions
  def sell_ticket
    @ticket_number - 1
    self.update
  end

  def tickets_available?
    return @ticket_number > 0
  end
end

require_relative('../db/sql_runner.rb')

class Film
  attr_reader :id
  attr_accessor :title, :price
  def initialize(options={})
    @title = options['title']
    @price = options['price']
    @id = options['id'].to_i if options['id']
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

end

require 'pry'
require_relative('../models/customer')
require_relative('../models/film')
require_relative('../models/ticket')

Customer.delete_all
Film.delete_all
Ticket.delete_all

customer1 = Customer.new({'name'=>'Tam', 'funds'=> 30})
customer1.save
customer2 = Customer.new({'name'=>'Mat', 'funds'=> 15})
customer2.save

film1 = Film.new({'title'=>'Pulp Fiction', 'price'=> 8})
film1.save
film2 = Film.new({'title'=>'Lion King', 'price'=> 5})
film2.save

ticket1 = Ticket.new({'customer_id' => customer1.id,'film_id' => film1.id})
ticket1.save
ticket2 = Ticket.new({'customer_id'=>customer1.id,'film_id'=>film2.id})
ticket2.save
ticket3 = Ticket.new({'customer_id'=>customer2.id,'film_id'=>film2.id})
ticket3.save


# p Customer.all
# p Film.all
# p Ticket.all
# customer1.delete
# film1.delete
# ticket1.delete
# film1.title = "Baby"
# film1.update
# p film1.title
# binding.pry
# ticket4 = Ticket.new()
# ticket4.customer_id = 2
# ticket4.film_id = 2
# ticket4.update
# p ticket4
# p customer1.films
p film1.customers

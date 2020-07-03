require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

require('pry-byebug')

Ticket.delete_all()
Customer.delete_all()
Film.delete_all()

customer1 = Customer.new({'name' => 'Ben', 'funds' => 50})
customer2 = Customer.new({'name' => 'Alina', 'funds' => 35})

customer1.save()
customer2.save()

customer1.name = "Benjamin"
customer1.update()

film1 = Film.new({'title' => 'Arrival', 'price' => 7})

film1.save()

film1.price = 8
film1.update()

ticket1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film1.id})

ticket1.save()

ticket1.customer_id = customer2.id
ticket1.update()

binding.pry
nil
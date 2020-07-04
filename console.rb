require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

require('pry-byebug')

Ticket.delete_all()
Customer.delete_all()
Film.delete_all()

customer1 = Customer.new({'name' => 'Ben', 'funds' => 50})
customer2 = Customer.new({'name' => 'Alina', 'funds' => 35})
customer3 = Customer.new({'name' => 'Julien', 'funds' => 13})
customer4 = Customer.new({'name' => 'Gabi', 'funds' => 5})

customer1.save()
customer2.save()
customer3.save()
customer4.save()

customer1.name = "Benjamin"
customer1.update()

film1 = Film.new({'title' => 'Arrival', 'price' => 7})
film2 = Film.new({'title' => 'Soul', 'price' => 6})

film1.save()
film2.save()

film1.price = 8
film1.update()

customer1.buy_ticket(film1)
customer4.buy_ticket(film1)

binding.pry
nil
require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')
require_relative('models/screening')

require('pry-byebug')

Ticket.delete_all()
Customer.delete_all()
Film.delete_all()

customer1 = Customer.new({'name' => 'Ben', 'funds' => 50})
customer2 = Customer.new({'name' => 'Alina', 'funds' => 35})
customer3 = Customer.new({'name' => 'Julien', 'funds' => 13})
customer4 = Customer.new({'name' => 'Gabi', 'funds' => 10})

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

screening1 = Screening.new({'time' => '20:45', 'film_id' => film1.id, 'max_capacity' => 50})
screening2 = Screening.new({'time' => '18:30', 'film_id' => film1.id, 'max_capacity' => 20})
screening3 = Screening.new({'time' => '17:30', 'film_id' => film2.id, 'max_capacity' => 45})
screening4 = Screening.new({'time' => '17:30', 'film_id' => film2.id, 'max_capacity' => 1})

screening1.save()
screening2.save()
screening3.save()
screening4.save()

customer1.buy_ticket(screening1)
customer3.buy_ticket(screening2)
customer4.buy_ticket(screening3)
customer2.buy_ticket(screening1)
customer4.buy_ticket(screening4)
customer2.buy_ticket(screening4)

binding.pry
nil
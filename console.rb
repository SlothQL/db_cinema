require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

require('pry-byebug')

Customer.delete_all()

customer1 = Customer.new({'name' => 'Ben', 'funds' => 50})
customer2 = Customer.new({'name' => 'Alina', 'funds' => 35})

customer1.save()
customer2.save()




binding.pry
nil
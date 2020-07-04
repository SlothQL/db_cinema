require_relative('../db/sql_runner')

class Customer

    attr_reader :id
    attr_accessor :name, :funds

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @name = options['name']
        @funds = options['funds'].to_i
    end

    def save()
        sql = "INSERT INTO customers 
        (name, funds) VALUES ($1, $2) RETURNING id"
        values = [@name, @funds]
        customer_data = SqlRunner.run(sql, values).first
        @id = customer_data['id'].to_i
    end

    def self.delete_all()
        sql = "DELETE FROM customers"
        SqlRunner.run(sql)
    end

    def delete()
        sql = "DELETE FROM customers WHERE id = $1"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def update()
        sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
        values = [@name, @funds, @id]
        SqlRunner.run(sql, values)
    end

    def self.all()
        sql = "SELECT * FROM customers"
        returned_customers = SqlRunner.run(sql)
        return returned_customers.map { |customer| Customer.new(customer) }
    end

    def films()
        sql = "SELECT films.* FROM films
        INNER JOIN screenings ON films.id = screenings.film_id
        INNER JOIN tickets ON tickets.screening_id = screenings.id
        WHERE customer_id = $1"
        values = [@id]
        all_films = SqlRunner.run(sql, values)
        return Film.map_data(all_films)
    end

    def self.map_data(data)
        result = data.map { |customer| Customer.new(customer) }
        return result
    end

    # extension

    def tickets()
        sql = "SELECT * FROM tickets WHERE customer_id = $1"
        values = [@id]
        ticket_data = SqlRunner.run(sql, values)
        return Ticket.map_data(ticket_data)
    end

    def number_of_tickets()
        tickets = self.tickets()
        return tickets.count()
    end

    def enough_money?(screening)
       film_price = screening.film_price() 
       return @funds >= film_price
    end

    def buy_ticket(screening)
        return if !enough_money?(screening)
        new_ticket = Ticket.new({'customer_id' => @id, 'screening_id' => screening.id})
        new_ticket.save()
        film_price = screening.film_price() 
        return @funds -= film_price
    end

end
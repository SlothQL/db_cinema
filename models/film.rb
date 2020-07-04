require_relative('../db/sql_runner')

class Film

    attr_reader :id
    attr_accessor :title, :price

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @title = options['title']
        @price = options['price'].to_i
    end

    def save()
        sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id"
        values = [@title, @price]
        film_data = SqlRunner.run(sql, values).first
        @id = film_data['id'].to_i
    end

    def self.delete_all()
        sql = "DELETE FROM films"
        SqlRunner.run(sql)
    end

    def delete()
        sql = "DELETE FROM films where id = $1"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def update()
        sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
        values = [@title, @price, @id]
        SqlRunner.run(sql, values)
    end

    def self.all()
        sql = "SELECT * FROM films"
        returned_films = SqlRunner.run(sql)
        return returned_films.map { |film| Film.new(film) }
    end

    def customers()
        sql = "SELECT customers.* FROM customers
        INNER JOIN tickets ON tickets.customer_id = customers.id 
        INNER JOIN screenings ON screenings.id = tickets.screening_id
        WHERE film_id = $1"
        values = [@id]
        all_customers = SqlRunner.run(sql, values)
        return Customer.map_data(all_customers)
    end

    def self.map_data(data)
        result = data.map { |film| Film.new(film) }
        return result
    end

    # extension

    def count_customers()
        customers = self.customers()
        return customers.count()
    end

    def tickets()
        sql = "SELECT tickets.* FROM tickets  
        INNER JOIN screenings on screenings.id = tickets.screening_id 
        WHERE film_id = $1"
        values = [@id]
        all_tickets = SqlRunner.run(sql, values)
        return Ticket.map_data(all_tickets)
    end

    def most_popular_time()
        all_screening_ids = []
        all_tickets = self.tickets()
        all_tickets.map { |ticket| all_screening_ids.push(ticket.screening_id)}
        favourite_screening_id = all_screening_ids.max_by { |i| all_screening_ids.count(i) }
        return Screening.find_by_id(favourite_screening_id).time
    end

    # https://medium.com/better-programming/two-ways-of-finding-the-element-that-occurs-the-most-in-an-array-with-ruby-7fb484ea1a6d

end
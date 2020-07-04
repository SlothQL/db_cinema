require_relative('../db/sql_runner')

class Screening

    attr_reader :id
    attr_accessor :time, :film_id, :max_capacity

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @time = options['time']
        @film_id = options['film_id'].to_i
        @max_capacity = options['max_capacity'].to_i
    end

    def save()
        sql = "INSERT INTO screenings 
        (time, film_id, max_capacity) VALUES ($1, $2, $3) RETURNING id"
        values = [@time, @film_id, @max_capacity]
        screening_data = SqlRunner.run(sql, values).first
        @id = screening_data['id'].to_i
    end

    def self.delete_all()
        sql = "DELETE FROM screenings"
        SqlRunner.run(sql)
    end

    def delete()
        sql = "DELETE FROM screenings WHERE id = $1"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def update()
        sql = "UPDATE screenings SET (time, film_id, max_capacity) = ($1, $2, $3) WHERE id = $4"
        values = [@time, @film_id, @max_capacity, @id]
        SqlRunner.run(sql, values)
    end

    def self.map_data(data)
        result = data.map { |screening| Screening.new(screening) }
        return result
    end

    def self.all()
        sql = "SELECT * FROM screenings"
        returned_screenings = SqlRunner.run(sql)
        return self.map_data(returned_screenings)
    end

    def self.find_by_id(id)
        sql = "SELECT * FROM screenings WHERE id = $1"
        values = [id]
        screening_data = SqlRunner.run(sql, values).first
        return self.new(screening_data)
    end

    def film_price()
        sql = "SELECT * FROM films WHERE id = $1"
        values = [@film_id]
        film_data = SqlRunner.run(sql, values).first
        return film_price = film_data['price'].to_i
    end

    def tickets()
        sql = "SELECT * FROM tickets WHERE screening_id = $1"
        values = [@id]
        all_tickets = SqlRunner.run(sql, values)
        return Ticket.map_data(all_tickets)
    end

    def count_tickets() 
        tickets = self.tickets()
        return tickets.count()
    end

    def available_seats()
        return @max_capacity - count_tickets()
    end

    def free_space?()
        return count_tickets() <= available_seats()
    end

    def decrease_available_seats()
        return available_seats() - 1
    end
end
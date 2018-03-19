class Movie < ActiveRecord::Base
    def self.ratings
       @rating = ['G','PG','PG-13','R']
    end
end

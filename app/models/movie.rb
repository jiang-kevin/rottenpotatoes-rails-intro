class Movie < ActiveRecord::Base
  def ratings
    ['G','PG','PG-13','R']
  end
end

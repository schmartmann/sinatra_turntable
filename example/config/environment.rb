require 'zlib' 


db = URI.parse(ENV['DATABASE_URL'] || 'postgres://dasboogaloo@localhost:5432/trout_fishing_db')

ActiveRecord::Base.establish_connection(
  :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme, 
  :host => db.host, 
  :username => db.user, 
  :password => db.password, 
  :database => db.path[1..-1], 
  :encoding => 'utf8' 
)


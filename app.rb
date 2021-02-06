
require "sinatra"
require "sinatra/activerecord"
# require "models/country"

set :database, {adapter: "sqlite3", database: "db/coin_inserts.sqlite3"}

class Country < ActiveRecord::Base
end

get '/' do
  erb :list, locals: { countries: Country.all }
end

post '/add_country' do
  Country.create!(params)
  redirect to('/')
end

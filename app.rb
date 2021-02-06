
require "sinatra"
require "sinatra/activerecord"
require "prawn"
require "prawn/measurement_extensions"

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

post '/update_country' do
  country = Country.find(params[:id])
  if params[:do] =='Update'
    country.update!(name: params[:name], years: params[:years])
  elsif params[:do] =='Delete'
    country.destroy
  end

  redirect to('/')
end

get "/generate" do

  Prawn::Document.generate("Coin inserts.pdf", left_margin: 0.25.in, bottom_margin: 0.5.in) do

    Country.all.each_slice(20) do |countries|

      puts "countries #{countries}"

      stroke do
        # Each page is a grid of 4w, 5h 2x2 squares
        columns = 4
        rows = 5
        width = height = 2.in

        columns.times do |column|
          x = column * width
          rows.times do |row|
            idx = column + row
            country = countries[idx]

            if country
              text country.name
            end

            y = 10.in - row * height
            rectangle [x, y], width, height
          end
        end
      end

    end
  end

  redirect to('/')
end

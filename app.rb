
require "sinatra"
require "sinatra/activerecord"
require "prawn"
require "prawn/measurement_extensions"
require 'shellwords'

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
    country.update!(name: params[:name], years: params[:years], flag_file_name: params[:flag_file_name])
  elsif params[:do] =='Delete'
    country.destroy
  end

  redirect to('/')
end

get "/generate" do

  Prawn::Document.generate("Coin inserts.pdf", left_margin: 0.25.in, bottom_margin: 0.5.in) do

    Country.all.each_slice(20) do |countries|

      # Each page is a grid of 4w, 5h 2x2 squares
      columns = 4
      rows = 5
      width = height = 2.in

      columns.times do |column|
        x = column * width
        rows.times do |row|

          # Figure out which country we're dealing with.
          # Just pluck the next one off the list
          idx = row * columns + column
          country = countries[idx]

          # So that we draw from top, start with our 10.in guide
          y = 10.in - row * height

          # Now we're drawing the grid square
          bounding_box([x, y], width: width, height: height) do

            # We don't need to draw anythine else if there is no country
            if country

              # Draw a slightly smaller bounding box to serve as a margin
              margin = 0.1.in
              inner_width = width - 2 * margin
              inner_height = height - 2 * margin

              bounding_box([margin, height - margin], width: inner_width, height: inner_height) do
                center_x = inner_width / 2
                center_y = inner_height / 2

                # Draw the flag
                file = "./flag_images/us-34-star-flag.jpg"
                image_x = 0
                image_y = inner_height
                image_height = inner_height / 2 - margin
                image_width = inner_width
                if !country.flag_file_name.nil? && File.exists?(file)
                  # image Shellwords.escape()
                  image file, height: image_height, position: :center
                end

                # Draw the country name
                fill_color '333333'
                country_name_x = 0
                country_name_y = center_y
                country_name_height = inner_height / 4
                country_name_width = inner_width
                text_box country.name, at: [country_name_x, country_name_y],
                          width: country_name_width,
                          height: country_name_height,
                          overflow: :shrink_to_fit,
                          size: 20,
                          min_font_size: 5,
                          align: :center

                # Draw the dates
                fill_color 'aaaaaa'
                years_x = 0
                years_y = inner_height / 4 - margin
                years_height = inner_height / 4
                years_width = inner_width
                text_box "(#{country.years})", at: [years_x, years_y],
                          width: years_width,
                          height: years_height,
                          overflow: :shrink_to_fit,
                          size: 12,
                          min_font_size: 5,
                          align: :center

              end

            end

            transparent(0.5) { stroke_bounds }
          end
        end
      end

    end
  end

  redirect to('/')
end







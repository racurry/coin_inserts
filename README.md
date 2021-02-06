# Coin Inserts

A very tiny app that I use to generate 2x2 inserts for coin album pages that look like this:

![example.png]

## How does it work
From the command line, run
```
bundle install
rackup
```
to grab dependencies and start the server.  Then go to [http://localhost:9292](http://localhost:9292) to run the app.

Add or edit the list of country data, and click "Generate" to get a new version of the pdf dumped out at `./Coin inserts.pdf`.

## Todo
- Start filling it with data
- Github pages-ify it
- Add images from the form, maybe?  Convert and get file name on the fly

## Long term
- Different 'groups'
  EU, US types, etc

## Built with
- Sinatra
- https://github.com/rmagick/rmagick
- https://prawnpdf.org/
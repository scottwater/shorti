# SHORTI

Shorti is an API first (and only) URL shortener and click counter. 

It is comprised of three end points.
| HTTP Method | End Point | Function 
| POST | / | Create a new shortened URL
| GET | /:id | Redirect to full URL and track the click
| GET | /info/:id | What URL is shortend and the number of clicks

The create end point will always require an API_KEY. The info end point can optionally require the API_KEY. 

## Installation 

1. Grab the source
1. bundle install
1. bundle exec rails db:setup 
1. bundle exec rails db:migrate 
1. bundle exec rails server 

## Specs 

`bundle exec rails spec` should do the trick.

## Configuration

| KEY | Description
| SHORTI_API_KEY | Controls access to create a new link. Optionally controls access to /info 
| SHORTI_BASE_URL | By default, Shorti will use the current request url, but you can optionally override it. 
| SHORTI_INFO_API_KEY | If this key exists, Shorti will require an API Key for the info end point


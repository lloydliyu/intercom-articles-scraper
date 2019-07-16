# Intercom-article-scraper

A simple project for Intercom to scrape articles from a public help center and allow access through a simple API.

Originally created: 14th July 2019

Last updated: 15th July 2019

## Problem to solve

Intercom currently doesn't have an Articles API or a way to export articles. This simple Rails project scrapes a specified help center for public facing articles and adds their data in to a Database to be queried against.

### Limitations

Cannot be used to scrape private articles, and has to have the help center slug from the `Default Help Center URL` within the help center basic settings page as this uses the default URL not a custom domain.

If setting up for own use, some things you may want to consider

 - Adding a rate limit to the controller actions
 - Using sidekiq and sidekiq-scheduler to automate the page scraping. I wouldn't recommend running more than once a week, especially on larger help centers.
 
 The scraper is run by using `Articles::Scrape.run(help_center_url: "")` with the `Default Help Center URL Slug` without `intercom.help` it should start with `/`.
 
 ## Dev Environment Install
 
 - Clone this repo on to your machine.
 - Insure bundler is installed with `sudo gem install bundler`.
 - Install dependencies with `bundle install`.
 - Update `config/database.yml` to use the adapter of choice.
 - If you are not using sqlite, you may need to create the database using `rake db:create`.
 - Migrate the database using `rake db:migrate`.
 - Run `rails c` to open the console and run the scraper command `Articles::Scrape.run(help_center_url: "")` with the `Default Help Center URL Slug` without `intercom.help` it should start with `/`.
 - Type `exit` to leave the console and then `rails s` to start the server.
 - You can then query all articles with a get request to `localhost:3000/api/v1/articles` or a specific article with `localhost:3000/api/v1/articles/:id`.
 - There is a delete route that you may wish to remove, this only removes articles from the local database and does not affect your help center.
 
 
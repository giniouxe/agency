Communication agency site with :
- home page as a landing page
- blog part

This site is deployed on http://agency-blog.herokuapp.com/

# How to install the project

Ruby version : 2.2.1
Rails version : 4.2.0

Git clone https://github.com/giniouxe/agency.git

Make sure you have the right versions of Ruby and Rails installed, then run:

`bundle install`

## Setup database

Create the Postgresql dev database named agency_dev.
See `config/database.yml` for username and password.

Then run:
`rake db:create`
`rake db:migrate`
`rake db:seed`

# Contributing

If you make improvements to this application, please share with others.

- Fork the project on GitHub.
- Make your feature addition or bug fix.
- Commit with Git.
- Send the author a pull request.

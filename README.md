this is an application to receive numbers, store them to a simeseries, and display a graph of the timeseries

# Running locally

	bundle install
	foreman start

# Deploying to heroku

	appname='whateveryouwant'
    heroku create appname
    heroku create --stack cedar appname
    heroku addons:add releases
    heroku addons:upgrade releases:advanced
    heroku addons:add ssl:piggyback
    heroku addons:add logging:expanded
require 'rubygems'
require "bundler/setup"
require 'sinatra'
require 'sequel'


module Points
  DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://rifgraf.db')
  
	def self.data
		@@data ||= make
	end

  def self.graphs
    DB[" SELECT DISTINCT(graph) FROM points"]    
  end

	def self.make
		make_table(DB)
		DB[:points]
	end

	def self.make_table(db)
		db.create_table :points do
			varchar :graph, :size => 32
			varchar :value, :size => 32
			timestamp :timestamp
		end
	rescue Sequel::DatabaseError
		# assume table already exists
	end
end


get '/' do
	erb :about
end

get '/graphs' do
  erb :graphs, :locals => {:graphs => Points.graphs.all}
end

get '/graphs/:id' do
	throw :halt, [ 404, "No such graph" ] unless Points.data.filter(:graph => params[:id]).count > 0
	erb :graph, :locals => { :id => params[:id] }, :layout=>false
end

get '/graphs/:id/amstock_settings.xml' do
	erb :amstock_settings, :locals => { :id => params[:id] }, :layout=>false
end

get '/graphs/:id/data.csv' do
  content_type 'text/csv'
	erb :data, :locals => { :points => Points.data.filter(:graph => params[:id]).reverse_order(:timestamp) }, :layout=>false
end

post '/graphs/:id' do
	Points.data << { :graph => params[:id], :timestamp => (params[:timestamp] || Time.now), :value => params[:value] }
	"ok"
end

delete '/graphs/:id' do
	Points.data.filter(:graph => params[:id]).delete
	"ok"
end

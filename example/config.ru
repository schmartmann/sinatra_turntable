require 'sinatra/activerecord'
require "sinatra/base"
# require "sinatra/reloader"
require_relative "server"
run Sinatra::Server

#!/usr/bin/env ruby
$LOAD_PATH.unshift(::File.dirname(__FILE__))
require 'rubygems'
require "bundler/setup"

require 'main.rb'
run Sinatra::Application

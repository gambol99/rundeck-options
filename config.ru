# puts File.join(File.dirname(__FILE__),'/libs')
$:.unshift File.join(File.dirname(__FILE__),'/lib')

require 'rack'
require 'sinatra'
require 'rundeck_options'

run RundeckOptions::Application

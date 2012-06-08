$: << File.expand_path(File.join(File.dirname(__FILE__), "lib"))
require "rubygems"
require "bundler/setup"

require 'sinatra'
require 'pivotal_activity'
require 'gs_chat_room'

chat_room = GsChatRoom.new(:host => "dogfood.groupsite.com",
                           :id => 1,
                           :username => "Pivotal Tracker",
                           :password => "d81f894c5c130f3f")

post '/pivotal-update' do
  request.body.rewind
  activity = PivotalActivity.from_xml request.body.read
  chat_room.post(activity.html_summary)
end

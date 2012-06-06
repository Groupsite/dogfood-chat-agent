require 'httparty'

class GsChatRoom
  attr_accessor :host, :id, :username, :password

  def initialize(attrs={})
    attrs.each do |attr, value|
      send("#{attr}=", value)
    end
  end

  def post_uri
    "http://#{host}/chat_rooms/#{id}/posts.json"
  end

  def auth_credentials
    {
      :username => username,
      :password => password
    }
  end

  def post(message)
    HTTParty.post(post_uri, :basic_auth => auth_credentials, :query => {:chat_post => {:message => message}})
  end
end

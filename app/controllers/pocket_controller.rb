require 'net/http'
require 'uri'
require 'json'

class PocketController < ApplicationController
  def auth
    url = 'https://getpocket.com/v3/oauth/request'
    body = {
      consumer_key: ENV["CONSUMER_KEY"],
      redirect_uri: 'http://localhost:3000'
    }

    # Make request 
    json_response = send_post_request(url, body)

    # Store in session cookie
    session[:request_token] = json_response["code"]

    # Redirect to authenticate
    redirect_url = "https://getpocket.com/auth/authorize?request_token=#{session[:request_token]}&redirect_uri=http://localhost:3000/pocket/pocket_redirect"
    puts redirect_url

    redirect_to redirect_url 
  end

  def pocket_redirect
    url = 'https://getpocket.com/v3/oauth/authorize'
    body = {
      consumer_key: ENV["CONSUMER_KEY"],
      code: session[:request_token]
    }

    # Make request 
    json_response = send_post_request(url, body)

    # Save access token in session
    session[:access_token] = json_response["access_token"]
    session[:username] = json_response["username"]

    redirect_to :action => "load_feed"
  end

  def load_feed
    url = 'https://getpocket.com/v3/get'
    body = {
      consumer_key: ENV["CONSUMER_KEY"],
      access_token: session[:access_token]
    }
    
    @json_response = send_post_request(url, body).to_json
  end

  private

  def send_post_request(url, body)
    uri = URI(url)
    header = {'Content-type': 'application/json', 'X-Accept': 'application/json'}

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = body.to_json

    # Send request
    response = http.request(request)
    json_response = JSON.parse(response.body)
    return json_response
  end
end

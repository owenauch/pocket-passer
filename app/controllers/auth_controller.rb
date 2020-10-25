require 'net/http'
require 'uri'
require 'json'

class AuthController < ApplicationController
  def auth
    uri = URI('https://getpocket.com/v3/oauth/request')
    header = {'Content-type': 'application/json', 'X-Accept': 'application/json'}
    body = {
      consumer_key: ENV["CONSUMER_KEY"],
      redirect_uri: 'http://localhost:3000'
    }
    puts "touch"
    puts ENV["CONSUMER_KEY"]

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = body.to_json

    # Send request
    response = http.request(request)

    # Store in session cookie
    json_response = JSON.parse(response.body)
    session[:request_token] = json_response["code"]

    # Redirect to authenticate
    redirect_url = "https://getpocket.com/auth/authorize?request_token=#{session[:request_token]}&redirect_uri=http://localhost:3000/auth/pocket_redirect"
    puts redirect_url

    redirect_to redirect_url 
  end

  def pocket_redirect
    uri = URI('https://getpocket.com/v3/oauth/authorize')
    header = {'Content-type': 'application/json', 'X-Accept': 'application/json'}
    body = {
      consumer_key: ENV["CONSUMER_KEY"],
      code: session[:request_token]
    }

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = body.to_json

    # Send request
    response = http.request(request)

    # Save access token in session
    json_response = JSON.parse(response.body)
    session[:access_token] = json_response["access_token"]
    session[:username] = json_response["username"]
  end
end

class ListItem < ApplicationRecord
  validates :item_id, uniqueness: true

  def pass_article
    new_times_skipped = self.times_skipped + 1
    self.update(times_skipped: new_times_skipped)
  end

  def archive(access_token)
    puts self.call_modify(access_token, "archive", self.item_id)
  end

  private

  def call_modify(access_token, action, item_id)
    uri = URI('https://getpocket.com/v3/send')
    header = {'Content-type': 'application/json', 'X-Accept': 'application/json'}
    body = {
      consumer_key: ENV['CONSUMER_KEY'],
      access_token: access_token,
      actions: [
        action: action,
        item_id: item_id
      ]
    }

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = body.to_json

    # Send request
    response = http.request(request)
    puts response.body
    json_response = JSON.parse(response.body)
    return json_response
  end

end

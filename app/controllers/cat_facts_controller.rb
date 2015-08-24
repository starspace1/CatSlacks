require 'JSON'
require 'httparty'

class CatFactsController < ApplicationController
  def index
    response = HTTParty.get('http://catfacts-api.appspot.com/api/facts?number=1')
    cat_hash = JSON.parse(response)
    @fact = cat_hash['facts'][0]
    if session[:access_token]
      response = HTTParty.get('https://slack.com/api/channels.list', query: { token: session[:access_token] })
      @channels = response.parsed_response["channels"]
    end
  end

  def send_message
    # Redirect user to authorize Slack
    if session[:access_token].nil?
      redirect_to root_url, notice: "You can't send a CAT FACT until you authorize Slack."
    else
      HTTParty.post('https://slack.com/api/chat.postMessage', query: {
        token: session[:access_token],
        channel: params[:channel_id],
        text: 'CAT FACT! ' + params[:fact],
        username: 'CatBot',
        icon_url: 'http://lorempixel.com/g/100/100/cats/' })
      redirect_to root_url, notice: 'Success! You sent a CAT FACT!'
    end
  end
end

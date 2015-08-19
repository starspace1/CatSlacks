require 'JSON'
require 'httparty'

class CatFactsController < ApplicationController
  def index
    response = HTTParty.get('http://catfacts-api.appspot.com/api/facts?number=1')
    cat_hash = JSON.parse(response)
    @fact = cat_hash['facts'][0]
  end

  def send_message
    # Redirect user to authorize Slack
    if session[:access_token].nil?
      redirect_to root_url, notice: "You can't send a CAT FACT until you authorize Slack."
    else
      # TODO: present a list of channels for user to select from
      # C04M51FHL is front-end, C06VD893L is orl, C04U2G8SM is rails
      HTTParty.post('https://slack.com/api/chat.postMessage', query: {
                      token: session[:access_token],
                      channel: 'C04U2G8SM',
                      text: 'CAT FACT! ' + params[:fact],
                      username: 'CatBot',
                      icon_url: 'http://lorempixel.com/g/100/100/cats/' })
      redirect_to root_url, notice: 'Success! You sent a CAT FACT!'
    end
  end
end

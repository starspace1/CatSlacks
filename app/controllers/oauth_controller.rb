class OauthController < ApplicationController
  def authorize
    client = OAuth2::Client.new(SLACK[:client_id], SLACK[:client_secret], :site => SLACK[:authorize_uri])
    redirect_to client.auth_code.authorize_url(:redirect_uri => SLACK[:redirect_uri])
  end

  def request_access_token
    if params[:code]
        response = HTTParty.get(SLACK[:api_url] + SLACK[:request_token_uri], query: {
        client_id:     SLACK[:client_id],
        client_secret: SLACK[:client_secret],
        code:          params[:code],
        redirect_uri:  SLACK[:redirect_uri]
      })
        session[:access_token] = response.parsed_response["access_token"]
      # client = OAuth2::Client.new(SLACK[:client_id], SLACK[:client_secret], :site => SLACK[:authorize_uri])
      # session[:access_token] = client.auth_code.get_token(params[:code], :redirect_uri => SLACK[:redirect_uri])
      redirect_to root_url, notice: "You can now post to Slack from this app. Token is #{session[:access_token]}"
    else
      redirect_to root_url, notice: "Fail. #{params}"
    end
  end
end
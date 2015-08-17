SLACK = { 
  client_id: ENV["SLACK_CLIENT_ID"],
  client_secret: ENV["SLACK_CLIENT_SECRET"],
  authorize_uri: "https://slack.com/oauth/authorize",
  redirect_uri: "http://localhost:3000/oauth/request_access_token",
  token_uri: "https://slack.com/api/oauth.access"
}
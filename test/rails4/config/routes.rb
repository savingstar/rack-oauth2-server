MyApp::Application.routes.draw do
  # Authorization flow.
  get "oauth/authorize", to: "oauth#authorize"
  post "oauth/grant", to: "oauth#grant"
  post "oauth/deny", to: "oauth#deny"

  # Resources we want to protect
  match "/:action", controller: "api", via: :all

  mount Rack::OAuth2::Server::Admin, at: "oauth/admin"
end

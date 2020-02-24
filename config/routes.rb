Rails.application.routes.draw do
  root to: 'games#new'
  post '/', to: 'games#new'
end

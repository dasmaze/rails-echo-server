Rails.application.routes.draw do
  # resource to create endpoints
  resources :endpoints, only: [:index, :show, :update, :destroy, :create]

  # this matches all routes and all verbs to echo according to created endpoints
  match '*echo_endpoint', to: 'echos#echo', via: :all, as: 'echo'
end

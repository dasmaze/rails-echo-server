Rails.application.routes.draw do
  resources :endpoints, only: [:index, :show, :update, :destroy, :create]
end

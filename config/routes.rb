Rails.application.routes.draw do
  root to: 'visitors#new'

  resources :visitors, only: [:new, :create, :index, :show]
  get 'soon' => "visitors#index"

  resources :users

end

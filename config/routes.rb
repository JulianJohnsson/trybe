Rails.application.routes.draw do
  root to: "pages#home"

  resources :visitors, only: [:new, :create, :index, :show]
  get 'soon' => "visitors#index"

  resources :users
  resources :facebook_posts  

  #facebook
  get "/callback" => "facebook_posts#callback"
  get "/facebook_profile" => "facebook#facebook_profile"
  get "/index" => "facebook_posts#index"
  get '/post'  => "facebook_posts#post"

end

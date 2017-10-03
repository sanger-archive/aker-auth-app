Rails.application.routes.draw do

  devise_scope :user do
    get 'login', to: 'users/sessions#new'
    delete 'logout', to: 'users/sessions#destroy'
    post 'logout', to: 'users/sessions#destroy'
    get '/', to: 'users/sessions#default'
    if Rails.env.test?
      # Dashboard app may not be available when testing, so spoof it
      get "/dashboard", to: 'users/sessions#default'
    end
  end

  devise_for :users, controllers: { sessions: 'users/sessions' }

end

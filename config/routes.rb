Rails.application.routes.draw do

  devise_scope :user do
    get 'login', to: 'users/sessions#new'
    delete 'logout', to: 'users/sessions#destroy'
    get '/', to: 'users/sessions#default'
  end

  devise_for :users, controllers: { sessions: 'users/sessions' }

end

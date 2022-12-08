Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root "posts#index"

  match "/404", to: 'errors#not_found', via: :all
  match "/500", to: 'errors#internal_server_error', via: :all
  
  get '/comments/:comment_id/new_reply', to: 'comments#new_reply', as: 'comment_reply'
  get '/comments/:comment_id/replies', to: 'comments#index_reply', as: 'comment_replies'

  resources :posts, except: [:new, :edit] do
    post 'like', on: :member

    resources :comments, shallow: true, only: [:create, :destroy, :index] do
      post 'like', on: :member
    end
  end
  
  resources :users, only: [:index, :show] do
    post 'unfriend', on: :collection
    get 'mail_sent', on: :member
  end

  scope '/friend_requests', as: :friend_request do
    post '/create', to: 'friend_requests#create'
    post '/cancel', to: 'friend_requests#cancel'
    post '/accept', to: 'friend_requests#accept'
    post '/reject', to: 'friend_requests#reject'
  end

  scope '/notifications', as: :notifications do
    get '', to: 'notifications#index'
    post '/:id/read', to: 'notifications#read', as: :read
    post '/read_all', to: 'notifications#read_all', as: :read_all
  end
end

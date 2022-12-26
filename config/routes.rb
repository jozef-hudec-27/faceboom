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
    post 'save', on: :member

    resources :comments, shallow: true, only: [:create, :destroy, :index] do
      post 'like', on: :member
    end
  end
  
  resources :users, only: [:index, :show] do
    post 'unfriend', on: :collection
    get 'mail_sent', on: :member
    get 'chat', on: :member, to: 'chats#show'
  end

  resources :messages, only: [:create, :destroy]
  put '/messages/:user_id/read_all', to: 'messages#read_all', as: :messages_read

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

  scope '/message_notifications', as: :message_notifications do
    put '/see_all', to: 'message_notifications#mark_all_seen', as: :see_all
    put '/:user_id/see', to: 'message_notifications#mark_seen', as: :see
  end
end

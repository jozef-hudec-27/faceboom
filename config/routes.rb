Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'
  }
  
  get '/comments/:comment_id/new_reply', to: 'comments#new_reply', as: 'comment_reply'
  get '/comments/:comment_id/replies', to: 'comments#index_reply', as: 'comment_replies'

  resources :posts do
    resources :comments, shallow: true, only: [:create, :edit, :destroy]
  end
  
  root "posts#index"
end

Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'
  }
  
  get '/comments/:comment_id/reply', to: 'comments#reply', as: 'comment_reply'

  resources :posts do
    resources :comments, shallow: true, only: [:create, :edit, :destroy]
  end
  
  root "posts#index"
end

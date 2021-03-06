require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  mount_roboto
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get 'users/sign_out', to: 'devise/sessions#destroy'
  end

  root 'pages#home'

  resources :users do
    member do
      patch 'activate'
      patch 'suspend'
    end
  end

  resources :posts
  authenticate :user, lambda { |u| u.admin? } do
    namespace :admin do
      resources :posts, only: %i[index]
    end
    namespace :api, default: { format: :json } do
      resources :posts
    end
  end

  resources :about_items, only: %i[index new edit create update destroy] do
    member do
      patch 'move_first'
      patch 'move_previous'
      patch 'move_next'
      patch 'move_last'
    end
  end
  get 'about', to: 'about_items#index'

  resources :histories, param: :generation_code do
    resources :activities, only: %i[index new edit create update destroy]
    resources :upload_files, only: %i[index new edit create update destroy] do
      member do
        post 'download'
      end
    end
  end

  resources :supporters, only: %i[index new edit create update destroy] do
    member do
      patch 'move_first'
      patch 'move_previous'
      patch 'move_next'
      patch 'move_last'
    end
  end

  resources :questions, only: %i[index new edit create update destroy]
  get 'faq', to: 'questions#index'

  resources :faq_categories, only: %i[index new edit create update destroy]

  resources :contacts, only: %i[new create]
  get 'contact', to: 'contacts#new'

  get '*not_found', to: 'application#routing_error'
  post '*not_found', to: 'application#routing_error'
end

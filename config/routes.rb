Rails.application.routes.draw do
  root to: 'homes#top'
  get 'home/about' => 'homes#about',as: 'about'
  devise_for :users
  resources :books, only: [:index, :show, :create, :edit, :destroy, :update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:index, :show, :create, :edit, :update]
  
  #devise_forはなるべく上に記述
  #:idによって別のルーティングが反映されること注意
  
  
  
end

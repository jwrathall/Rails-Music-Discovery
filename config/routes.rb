DevMusicCom::Application.routes.draw do

  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  get "user/new"
  get "user/sign_in"
  get "user/forgot_password"
  get "user/change_password"
 # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'index#index'
  post 'artist/', :to => 'index#get'
  get 'artist/releases/:id', :to => 'releases#index', as: :releases
  get 'artist/release', :to => 'release#index', as: :release
  get 'artist/similar/:id', :to => 'similar#index', as: :similar
  get 'artist/tours/:id', :to => 'tours#index', as: :tour
  post 'user/save_artist', :to => 'user_artists#save'
  delete 'user/destroy_artist', :to => 'user_artists#destroy'
  #just the api endpoint, not a real page
  get 'user/all_artists', :to =>  'user_artists#index'
  get 'user/catalog', :to => 'catalog#index', as: :catalog
  get 'register', :to => 'user#new', as: :register
  get 'sign_in', :to => 'user#sign_in', as: :signin
  post 'register', :to => 'user#create', as: :create
  get 'forgot_password', :to => 'user#forgot_password', as: :recover
  get 'change_password', :to => 'user#change_password', as: :edit



  resources :index, defaults: {format: :json}, only: [:index]  do


    #namespace :artist do
    #  resources :releases, :release, :tours, :similar_artist
    #end
  end


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

Episcoplus::Application.routes.draw do
  # route for the homepage
  root :to => 'pages#home'

  # named routes for static pages, signup, login and logout
  match '/welcome', to: 'pages#welcome'
  match '/about', to: 'pages#about'
  match '/contact', to: 'pages#contact'
  match '/faq', to: 'pages#faq'
  match '/search', to: 'pages#search'

  match '/signup', to: 'users#new'
  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  # routes for the Users controller (default plus following, followers and search)
  resources :users do
    # member: apply the reported actions to each single member (to /users/{:id}, in this case)
    member do
      get :following, :followers, :messages # ex.: get /users/1/followers
    end
    # collection: apply the reported action to the entire collection (to /users/, in this case)
    collection do
      get :search
    end
  end

  # default routes for the Sessions controller (only new, create and destroy)
  resources :sessions, only: [:new, :create, :destroy]

  # default routes for the Posts controller (only create and destroy - other operations will be done via the Users controller)
  resources :posts, only: [:create, :destroy]

  # default routes for the Messages controller
  resources :messages

  # default routes for the Relationship controller (only create and destroy) - needed to build follow/unfollow relations
  resources :relationships, only: [:create, :destroy]

  # default routes for the Sermon controller (only create and destroy)
  resources :sermons

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

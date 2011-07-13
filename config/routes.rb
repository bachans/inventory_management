InventoryManagement::Application.routes.draw do

  resources :private_orders

  resources :invoices

  resources :cart_items

  resources :orders

  resources :customers

	resources :artists

	resources :albums

	resources :users
	
	resources :public, :only => [:list, :show, :add_to_cart, :show_cart, :empty_cart, :remove_item, :checkout, :save_order, :report]
	resources :private, :only => [:list, :add_private_cart, :private_showcart, :remove_private_item, :empty_private_cart, :show_private_checkout, :save_private_order, :private_report]
	#session
	resources :sessions, :only => [:new, :create, :destroy]

	match '/', :to => 'pages#home'
	
	# the path for the sign up.
	match '/signup', :to => 'users#new'
	match '/home', :to => 'users#home' 
	match '/testmail' => 'users#mail'
	
	#the path for the list in public
	match '/list', :to => 'public#list'
	match '/showalbum', :to => 'public#showalbum'
	match '/addtocart', :to => 'public#add_to_cart'
	match '/showcart', :to => 'public#show_cart'
	match '/emptycart', :to => 'public#empty_cart'
	match '/removeitem', :to => 'public#remove_item'
	match '/checkout', :to => 'public#checkout'
  match '/saveorder', :to => 'public#save_order'
  match '/report', :to => 'public#report'
	
  #path for private
  match '/privatealbums', :to => 'private#list'
  match '/addprivatecart', :to => 'private#add_private_cart'
  match '/privateshowcart', :to => 'private#private_showcart'
  match '/removeprivateitem', :to => 'private#remove_private_item'
  match '/emptyprivatecart', :to => 'private#empty_private_cart'
  match '/privatecheckout', :to => 'private#private_checkout'
  match '/showprivatecheckout', :to => 'private#show_private_checkout'
  match '/saveprivateorder', :to => 'private#save_private_order'
  match '/privatereport/:invoice' => 'private#private_report'

  
	#session 
	match '/signin', :to => 'sessions#new'
	match '/signout', :to => 'sessions#destroy'
	
	root :to => 'pages#home'
	
	
	
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

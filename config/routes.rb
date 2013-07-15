QueryGateway::Application.routes.draw do

  resources :results, :only => [:index, :show]
  
  resources :queries
  post 'queries/upload_hqmf'

  post 'pmn/create' # not sure why this required given the following line but tests break without it
  post 'pmn/PostRequest/:pmn_request_id', :to => 'pmn#create'
  post 'pmn/PostRequestDocument/:id/:doc_id/:offset', :to => 'pmn#add'
  put 'pmn/Start/:id', :to => 'pmn#start'
  post 'pmn/Stop/:id', :to => 'pmn#stop'
  get 'pmn/GetStatus/:id', :to => 'pmn#status'
  get 'pmn/GetResponse/:id', :to => 'pmn#get_response'
  get 'pmn/GetResponseDocument/:id/:doc_id/:offset', :to => 'pmn#doc'
  get 'pmn/Close/:id', :to => 'pmn#close'
  
  get 'hdata/index'
  get 'hdata/root'

  post 'records/create'
  delete 'records/destroy'
  
  post 'library_functions', :to => "library_functions#create"
  
  root :to => 'queries#index'
  
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
  # match ':controller(/:action(/:id(.:format)))'
end

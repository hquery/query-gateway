QueryGateway::Application.routes.draw do

  get 'sysinfo/load', :constraints => {:ip => /127.0.0.1/}
  get 'sysinfo/users', :constraints => {:ip => /127.0.0.1/}
  get 'sysinfo/diskspace', :constraints => {:ip => /127.0.0.1/}
  get 'sysinfo/mongo', :constraints => {:ip => /127.0.0.1/}
  get 'sysinfo/processes', :constraints => {:ip => /127.0.0.1/}
  get 'sysinfo/swap', :constraints => {:ip => /127.0.0.1/}
  get 'sysinfo/import', :constraints => {:ip => /127.0.0.1/}
  get 'sysinfo/tomcat', :constraints => {:ip => /127.0.0.1/}

  resources :results, :only => [:index, :show]
  
  resources :queries
  post 'queries/upload_hqmf', :constraints => {:ip => /127.0.0.1/}

  post 'pmn/create', :constraints => {:ip => /127.0.0.1/} # not sure why this required given the following line but tests break without it
  post 'pmn/PostRequest/:pmn_request_id', :to => 'pmn#create', :constraints => {:ip => /127.0.0.1/}
  post 'pmn/PostRequestDocument/:id/:doc_id/:offset', :to => 'pmn#add', :constraints => {:ip => /127.0.0.1/}
  put 'pmn/Start/:id', :to => 'pmn#start', :constraints => {:ip => /127.0.0.1/}
  post 'pmn/Stop/:id', :to => 'pmn#stop', :constraints => {:ip => /127.0.0.1/}
  get 'pmn/GetStatus/:id', :to => 'pmn#status', :constraints => {:ip => /127.0.0.1/}
  get 'pmn/GetResponse/:id', :to => 'pmn#get_response', :constraints => {:ip => /127.0.0.1/}
  get 'pmn/GetResponseDocument/:id/:doc_id/:offset', :to => 'pmn#doc', :constraints => {:ip => /127.0.0.1/}
  get 'pmn/Close/:id', :to => 'pmn#close', :constraints => {:ip => /127.0.0.1/}
  
  get 'hdata/index', :constraints => {:ip => /127.0.0.1/}
  get 'hdata/root', :constraints => {:ip => /127.0.0.1/}

  post 'records/create', :constraints => {:ip => /127.0.0.1/}
  delete 'records/destroy', :constraints => {:ip => /127.0.0.1/}
  
  post 'library_functions', :to => "library_functions#create", :constraints => {:ip => /127.0.0.1/}
  
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

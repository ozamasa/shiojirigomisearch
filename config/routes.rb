ActionController::Routing::Routes.draw do |map|
  map.resources :areas, :collection => {:check => :post}, :member => {:confirm => :put, :edit => :put}

  map.resources :collect_dates, :collection => {:check => :post}, :member => {:confirm => :put, :edit => :put}

  map.resources :categories, :collection => {:check => :post}, :member => {:confirm => :put, :edit => :put}

  map.resources :garbages, :collection => {:check => :post}, :member => {:confirm => :put, :edit => :put}

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.root             :controller => :auth,   :action => :login
  map.top     'top',   :controller => :top,    :action => :index

  map.connect '/tab',  :controller => :tab,    :action => :index

  map.connect '/mobile/calendar/:area',  :controller => :mobile, :action => :calendar, :conditions => {:method => :get}
  map.connect '/mobile/search/:keyword', :controller => :mobile, :action => :search,   :conditions => {:method => :get}
  map.connect '/mobile/garbage/:id',     :controller => :mobile, :action => :garbage,  :conditions => {:method => :get}

  map.connect '/databases',                    :controller => :databases, :action => :list
  map.connect '/database/:tablename.:format',  :controller => :databases, :action => :index
  map.connect '/database/new/:tablename',      :controller => :databases, :action => :new
  map.connect '/database/cre/:tablename',      :controller => :databases, :action => :create, :conditions => { :method => :post   }
  map.connect '/database/:tablename/:id/edit', :controller => :databases, :action => :edit
  map.connect '/database/:tablename/:id',      :controller => :databases, :action => :update, :conditions => { :method => :put    }
  map.connect '/database/:tablename/:id',      :controller => :databases, :action => :destroy,:conditions => { :method => :delete }

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect '*path', :controller => :application, :action => :error

end

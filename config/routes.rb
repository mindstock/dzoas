Dzoas::Application.routes.draw do
  resources :bags

  resources :powers

  resources :roles

  resources :messages

  devise_scope :user do
    get '/login', :to => "admin/sessions#new"
    get '/test', :to => "admin/sessions#test"
  end
  devise_for :users,
             :controllers => {
                :sessions => "admin/sessions",
                :passwords => "admin/passwords"
              } 

              
  resources :welcomes
  get '/top' => 'welcomes#top'
  get '/left' => 'welcomes#left'
  get '/middle' => 'welcomes#middle'
  get '/main' => 'welcomes#main'

  resources :employees
  get '/employees/sys/users/new_sys' => 'employees#new_sys'
  get '/employees/sys/users/list' => 'employees#sys'
  get '/employees/sys/users/del' => 'employees#sys_del'

  resources :quclity_checks

  resources :departments

  resources :nickelclads

  resources :plans
  get '/plans/search/tapes' => 'plans#search_tapes'
  get '/plans/search/format_html' => 'plans#get_format_html'
  get '/plans/spread/:department' => 'plans#spread'
  get '/plans/spread/status/:status' => 'plans#check_plan_status'
  get '/plans/spread/status/update/:id/:status' => 'plans#update_status'
  get '/plans/spread/complete_plan/:id' => 'plans#complete_plan'
  get '/plans/send/message' => 'plans#send_message'
  post '/plans/:id' => 'plans#update'
  get '/plans/create/:ids' => 'plans#create_plan'

  resources :tapes
  get '/tapes/store/upload_file' => 'tapes#upload_file'
  post '/tapes/store/search' => 'tapes#search'
  post '/tapes/upload' => 'tapes#upload'
  post '/plans/tape/search' => 'tapes#plan_search'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
  root 'plans#index'

end

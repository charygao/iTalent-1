Italentapp::Application.routes.draw do
  
  devise_for :users
  resources :tags, except: :index
  
  resources :publications do
    resource :like, only: [:create, :destroy] # singular resource. the user always likes from his account
    resources :comments do
      post 'load', on: :collection
    end
    post 'load', on: :collection
  end

  resources :subscriptions, only: [:create, :destroy]
  resources :events

  resources :event_invitations, only: :create
  
  resources :timeline, only: [:index]
  resources :event_attendees, only: [:create, :destroy]

  

  devise_scope :user do
    authenticated :user do

      namespace :user do
        get '/dashboard', to: 'dashboard#index'

        resources :publications
        resources :events
        resources :event_attendees, only: [:create, :destroy]
        resources :tags do
          collection do 
            post 'edit_multiple'
            put 'update_multiple'
          end
        end
        
        root to: 'dashboard#index', as: :user_root
      end

      namespace :admin do
        resources :tags
        resources :users
        root 'users#index', as: :admin_root
      end

      root 'timeline#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

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
end

Ctl::Application.routes.draw do
  
  scope Settings.get('scope') do
    
    namespace :admin do
      root to: 'splash#index'
    end
    
    # app routes
    get 'show/(:country)/(:city)/(:km)' => 'kms#show', as: :show
    get 'compare' => 'kms#compare', as: :compare
    
    # wildcard routes
    get ':controller(/:action(/:id))'
    post ':controller(/:action(/:id))'
    
    # wildcard admin routes
    get ':controller(/:action(/:id))', controller: /admin\/[^\/]+/
    post ':controller(/:action(/:id))', controller: /admin\/[^\/]+/
    
    # wildcard api routes
    get ':controller(/:action(/:id))', controller: /api\/[^\/]+/
    post ':controller(/:action(/:id))', controller: /api\/[^\/]+/
    
    root to: 'splash#index'
    
  end
  
end

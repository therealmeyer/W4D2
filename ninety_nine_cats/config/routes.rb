Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :cats do 
    resources :cat_rental_requests, only: [:index, :new, :destroy, :create]
    resources :cat_rental_requests do
      member do 
        post 'approve'
        post 'deny'
      end
    end
  end
  
  
  
end

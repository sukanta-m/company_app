Rails.application.routes.draw do
  resources :companies do
    collection do
      get :startup, :mid_size, :established
    end

    resources :branches
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do

  root 'dashboard#index'

  resources :weigh_ins, only: [:index] do
    post :upload, on: :collection
  end

  resources :stats, only: [:index] do
    collection do
      get :weekly_averages
      get :predictions
  end
  end
end

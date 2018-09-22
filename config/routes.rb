Rails.application.routes.draw do

  root 'dashboard#index'

  resources :weigh_ins, only: [:index] do
    post :upload, on: :collection
  end
end

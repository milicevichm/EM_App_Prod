Rails.application.routes.draw do

  resources :power_forms

  get 'static_pages/home'

  get 'static_pages/about'

  root 'static_pages#home'

end

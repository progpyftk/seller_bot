Rails.application.routes.draw do
  get 'fulfillment/index'
  get 'fulfillment/to-increase-stock', to: 'fulfillment#to_increase_stock'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

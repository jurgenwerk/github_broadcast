Rails.application.routes.draw do
  post 'store_location' => 'application#store_location'

  mount ActionCable.server => '/cable' # to run in the same process as server
end

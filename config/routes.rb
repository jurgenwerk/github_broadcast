Rails.application.routes.draw do
  mount ActionCable.server => '/cable' # to run in the same process as server
end

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'recipients/create'
      get  'recipients/list'

      post 'payments/create'
      get  'payments/list'
      get  'payments/verify'
    end
  end
end

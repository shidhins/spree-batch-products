Spree::Core::Engine.routes.append do
  # Add your extension routes here
  namespace :admin do
    resources :product_datasheets do
      collection do
        get 'download', to: 'product_datasheets#download'
      end
    end
  end
end

Spree::Product.class_eval do
  scope :for_backup, -> {includes(:master).active}
  FIELDS_FOR_BACKUP = ['sku', 'name', 'price', 'weight', 'description', 'slug']
end

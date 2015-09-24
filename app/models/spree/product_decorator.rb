Spree::Product.class_eval do
  scope :for_backup, -> {
    preload(:master => :prices).
    where("#{quoted_table_name}.available_on <= ?", Time.now)
  }
  def self.fields_for_backup
    ["id","name","description","available_on","deleted_at","slug","meta_description","meta_keywords","tax_category_id","shipping_category_id","created_at","updated_at","promotionable","meta_title","tagline"]
  end
end

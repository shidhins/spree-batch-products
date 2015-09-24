Spree::Variant.class_eval do

  scope :for_backup, -> { where("#{quoted_table_name}.sku IS NOT NULL") }
  def self.fields_for_backup
    ["sku","weight","height","width","depth","deleted_at","is_master","product_id","cost_price","position","cost_currency","track_inventory","tax_category_id","updated_at","stock_items_count"]
  end
end

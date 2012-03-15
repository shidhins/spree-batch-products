class AddIndexBySkuToVariants < ActiveRecord::Migration
  def self.up
    if table_exists?('variants')
      add_index :variants, :sku
    elsif table_exists?('spree_variants')
      add_index :spree_variants, :sku
    end
  end

  def self.down
    if table_exists?('variants')
      remove_index :variants, :sku
    elsif table_exists?('spree_variants')
      remove_index :spree_variants, :sku
    end
  end
end

class AddIndexBySkuToVariants < ActiveRecord::Migration
  def self.up
    add_index :variants, :sku
  end

  def self.down
    remove_index :variants, :sku
  end
end

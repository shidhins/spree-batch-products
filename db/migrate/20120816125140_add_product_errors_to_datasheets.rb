class AddProductErrorsToDatasheets < ActiveRecord::Migration
  def self.up
    add_column :product_datasheets, :product_errors, :text
  end

  def self.down
    remove_column :product_datasheets, :product_errors
  end
end

class AddFieldsToProperties < ActiveRecord::Migration[8.0]
  def change
    add_column :properties, :listing_type, :string
    add_column :properties, :amenities, :text
    add_column :properties, :available_from, :date
    add_column :properties, :pincode, :string
  end
end


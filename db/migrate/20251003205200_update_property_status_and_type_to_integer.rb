class UpdatePropertyStatusAndTypeToInteger < ActiveRecord::Migration[8.0]
  def up
    # Change status from string to integer
    add_column :properties, :status_integer, :integer, default: 0, null: false
    
    # Migrate existing data
    Property.reset_column_information
    Property.find_each do |property|
      case property.status
      when 'available', 'Available', nil
        property.update_column(:status_integer, 0)
      when 'sold', 'Sold'
        property.update_column(:status_integer, 1)
      when 'ongoing', 'Ongoing'
        property.update_column(:status_integer, 2)
      when 'rented', 'Rented'
        property.update_column(:status_integer, 3)
      else
        property.update_column(:status_integer, 0)
      end
    end
    
    remove_column :properties, :status
    rename_column :properties, :status_integer, :status
    
    # Change property_type from string to integer
    add_column :properties, :property_type_integer, :integer, default: 0, null: false
    
    # Migrate existing data
    Property.reset_column_information
    Property.find_each do |property|
      type_value = case property.property_type&.downcase
      when 'house'
        0
      when 'apartment'
        1
      when 'condo'
        2
      when 'land'
        3
      when 'commercial'
        4
      else
        0
      end
      property.update_column(:property_type_integer, type_value)
    end
    
    remove_column :properties, :property_type
    rename_column :properties, :property_type_integer, :property_type
    
    add_index :properties, :status
    add_index :properties, :property_type
  end
  
  def down
    remove_index :properties, :status
    remove_index :properties, :property_type
    
    change_column :properties, :status, :string
    change_column :properties, :property_type, :string
  end
end



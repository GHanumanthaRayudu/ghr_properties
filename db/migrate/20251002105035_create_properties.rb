class CreateProperties < ActiveRecord::Migration[8.0]
  def change
    create_table :properties do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.string :property_type
      t.string :status
      t.text :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.decimal :latitude
      t.decimal :longitude
      t.integer :bedrooms
      t.integer :bathrooms
      t.decimal :area
      t.boolean :furnished
      t.boolean :parking
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateInquiries < ActiveRecord::Migration[8.0]
  def change
    create_table :inquiries do |t|
      t.references :customer, null: false, foreign_key: { to_table: :users }
      t.references :property, null: false, foreign_key: true
      t.text :message, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :inquiries, :status
    add_index :inquiries, [:property_id, :customer_id]
  end
end



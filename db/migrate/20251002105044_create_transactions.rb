class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :property, null: false, foreign_key: true
      t.references :buyer, null: false, foreign_key: { to_table: :users }
      t.references :seller, null: false, foreign_key: { to_table: :users }
      t.string :status
      t.string :transaction_type
      t.decimal :amount
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end

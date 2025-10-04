class AddPhoneAndOtpToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :phone_number, :string
    add_column :users, :otp_code, :string
    add_column :users, :otp_sent_at, :datetime
    add_column :users, :phone_verified_at, :datetime
    add_column :users, :otp_attempts, :integer, default: 0
    
    add_index :users, :phone_number, unique: true
  end
end



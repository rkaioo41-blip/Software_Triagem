class AddResetPasswordToEnfermeiros < ActiveRecord::Migration[8.0]
  def change
    add_column :enfermeiros, :reset_password_token, :string
    add_column :enfermeiros, :reset_password_sent_at, :datetime
    add_index :enfermeiros, :reset_password_token, unique: true
  end
end

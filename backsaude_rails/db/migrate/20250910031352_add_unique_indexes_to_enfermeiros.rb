class AddUniqueIndexesToEnfermeiros < ActiveRecord::Migration[8.0]
  def change
    add_index :enfermeiros, :email, unique: true
    add_index :enfermeiros, :coren, unique: true
    add_index :enfermeiros, :cpf, unique: true
  end
end

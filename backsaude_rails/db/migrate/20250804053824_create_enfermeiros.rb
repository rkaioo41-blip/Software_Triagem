class CreateEnfermeiros < ActiveRecord::Migration[8.0]
  def change
    create_table :enfermeiros do |t|
      t.string :nome
      t.date :data_nascimento
      t.string :cpf
      t.string :sexo
      t.string :email
      t.string :coren
      t.string :uf
      t.string :instituicao
      t.string :senha_digest

      t.timestamps
    end
  end
end

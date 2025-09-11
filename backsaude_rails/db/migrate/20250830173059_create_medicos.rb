class CreateMedicos < ActiveRecord::Migration[8.0]
  def change
    create_table :medicos do |t|
      t.string :nome
      t.string :CRM
      t.string :email
      t.time :hora_inicio
      t.time :hora_fim
      t.string :especialidade
      t.timestamps
    end
  end
end

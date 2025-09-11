class CreatePacienteFakes < ActiveRecord::Migration[8.0]
  def change
    create_table :paciente_fakes do |t|
      t.string :codigo_sus
      t.string :nome
      t.string :cpf
      t.string :sexo
      t.string :endereco
      t.date   :data_nascimento
      t.string :cidade
      t.string :nome_pai
      t.string :nome_mae
      t.string :raca_cor
      t.string :orientacao_sexual
      t.string :identidade_genero
      t.string :nome_social

      t.timestamps
    end
  end
end

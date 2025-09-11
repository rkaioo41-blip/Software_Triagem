class AddMedicoToRelatorioTriagem < ActiveRecord::Migration[8.0]
  def change
    add_reference :relatorio_triagems, :medico, foreign_key: true
  end
end

class ChangeClassificacaoRiscoToClassificacaoRiscoIdInRelatorioTriagems < ActiveRecord::Migration[8.0]
  def change
    rename_column :relatorio_triagems, :classificacao_risco, :classificacao_risco_id
  end
end

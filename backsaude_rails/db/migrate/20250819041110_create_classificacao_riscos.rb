class CreateClassificacaoRiscos < ActiveRecord::Migration[8.0]
  def change
    create_table :classificacao_riscos do |t|
      t.string :nivel, null: false                  # vermelho, laranja, amarelo, verde, azul
      t.string :nome_nivel, null: false             # "Emergência", "Muito Urgente", etc.
      t.string :tempo_atendimento, null: false      # "Atendimento imediato", "Até 10 minutos", etc.
      t.text   :descricao
      t.jsonb  :exemplos, null: false, default: []  # [{texto:, icone:}, ...]

      t.timestamps
    end

    add_index :classificacao_riscos, :nivel, unique: true
  end
end

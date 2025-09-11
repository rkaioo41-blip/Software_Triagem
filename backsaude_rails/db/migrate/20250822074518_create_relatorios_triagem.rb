class CreateRelatoriosTriagem < ActiveRecord::Migration[8.0]
  def change
    create_table :relatorio_triagems do |t|
      # Referências corretas
      t.references :paciente_fake, null: false, foreign_key: { to_table: :paciente_fakes }
      t.references :enfermeiro, null: false, foreign_key: true

      # Dados principais do relatório
      t.string :classificacao_risco
      t.string :protocolo
      t.datetime :data_triagem

      # PDF
      t.text :pdf_data
      t.string :pdf_file_name
      t.string :pdf_content_type
      t.integer :pdf_file_size

      # Campos JSON para armazenar dados completos
      t.jsonb :dados, default: {}

      t.timestamps
    end
  end
end

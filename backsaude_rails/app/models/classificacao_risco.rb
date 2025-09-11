# app/models/classificacao_risco.rb
class ClassificacaoRisco < ApplicationRecord
  # Validações
  validates :nivel, presence: true, uniqueness: true
  validates :nome_nivel, :tempo_atendimento, presence: true
  validates :exemplos, presence: true
end

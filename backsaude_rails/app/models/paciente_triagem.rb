class PacienteTriagem < ApplicationRecord
  # Status: aguardando, finalizada - NOVA SINTAXE OBRIGATÓRIA NO RAILS 8+
  enum :status, { aguardando: 0, finalizada: 1 }

  validates :nome, :codigo_sus, :data_nascimento, presence: true
  validates :codigo_sus, uniqueness: true
end

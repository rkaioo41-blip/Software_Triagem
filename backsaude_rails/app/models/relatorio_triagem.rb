class RelatorioTriagem < ApplicationRecord
  belongs_to :paciente_fake, optional: true
  belongs_to :enfermeiro, optional: true
  belongs_to :classificacao_risco, optional: true
  belongs_to :medico, optional: true
  validates :protocolo, presence: true
  validates :data_triagem, presence: true



  store_accessor :dados, :sinais_vitais, :sintomas, :prioridades, :comorbidades, :alergias
end

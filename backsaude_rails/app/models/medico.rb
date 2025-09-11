class Medico < ApplicationRecord
  validates :nome, presence: true
  validates :CRM, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :hora_inicio, presence: true
  validates :hora_fim, presence: true

  has_many :relatorio_triagems
end

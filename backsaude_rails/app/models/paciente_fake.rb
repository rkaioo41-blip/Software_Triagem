class PacienteFake < ApplicationRecord
  validates :codigo_sus, presence: true, uniqueness: true
  validates :nome, presence: true
  validates :data_nascimento, presence: true
end

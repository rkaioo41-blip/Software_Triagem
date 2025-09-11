
require "argon2"

class Enfermeiro < ApplicationRecord
  validates :nome, :coren, :email, :instituicao, presence: true
  validates :email, uniqueness: true
  validates :coren, uniqueness: true
  validates :email, uniqueness: true

  attr_reader :password
  validates :password, length: { minimum: 8 }, if: :password_required?

  before_save :hash_password_with_argon2, if: :password_present?

  def password=(raw)
    @password = raw
    @password_changed = true
  end

  def authenticate(raw)
    return false if password_digest.blank?

    peppered = add_pepper(raw)
    Argon2::Password.verify_password(peppered, password_digest)
  end

  private

  def password_required?
    new_record? || @password_changed
  end

  def password_present?
    @password.present?
  end

  def hash_password_with_argon2
    peppered = add_pepper(@password)
    self.password_digest = Argon2::Password.create(
      peppered,
      t_cost: 3,   # número de iterações
      m_cost: 16   # custo de memória em MB
    )
  end

  # Aplica apenas o pepper
  def add_pepper(raw)
    secret = Rails.application.credentials.password_pepper || ENV["PASSWORD_PEPPER"]
    raise "PASSWORD_PEPPER não definido!" if secret.nil?

    "#{raw}#{secret}"
  end
end

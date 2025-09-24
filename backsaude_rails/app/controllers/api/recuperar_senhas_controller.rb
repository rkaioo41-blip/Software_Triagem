class Api::RecuperarSenhasController < ApplicationController
  before_action :find_enfermeiro_by_token, only: [ :update ]

  def create
    identificador = params[:identificador].to_s.downcase.strip
    enfermeiro = Enfermeiro.find_by("LOWER(email) = ? OR LOWER(coren) = ?", identificador, identificador)

    if enfermeiro.nil?
      render json: { erro: "Usuário não encontrado." }, status: :unprocessable_entity
      return
    end

    token = SecureRandom.hex(20)
    enfermeiro.update!(
      reset_password_token: token,
      reset_password_sent_at: Time.current
    )

    RecuperarSenhaMailer.with(enfermeiro: enfermeiro, token: token).instrucoes.deliver_later

    render json: { mensagem: "Instruções de redefinição de senha enviadas para seu e-mail." }
  end

  def update
    # CORREÇÃO: Acessar o password dentro do hash enfermeiro
    nova_senha = params.dig(:enfermeiro, :password).to_s.strip

    if nova_senha.blank?
      render json: { erro: "Senha não pode ficar em branco." }, status: :unprocessable_entity
      return
    end

    if @enfermeiro.update(password: nova_senha, reset_password_token: nil, reset_password_sent_at: nil)
      render json: { mensagem: "Senha atualizada com sucesso." }
    else
      render json: { erro: @enfermeiro.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private

  def find_enfermeiro_by_token
    token = params[:token].to_s
    @enfermeiro = Enfermeiro.find_by(reset_password_token: token)

    if @enfermeiro.nil?
      render json: { erro: "Token inválido ou expirado." }, status: :unprocessable_entity
    end
  end
end


module Api
  class SessoesController < ApplicationController
    def create
      identificador = params[:identificador].to_s.downcase.strip
      cpf_limpo   = identificador.gsub(/[^0-9]/, "")
      coren_limpo = identificador.gsub(/\s+/, "").upcase

      enfermeiro =
        Enfermeiro.find_by("LOWER(email) = ?", identificador) ||
        Enfermeiro.find_by(cpf: cpf_limpo) ||
        Enfermeiro.find_by("UPPER(REPLACE(coren, ' ', '')) = ?", coren_limpo)

      if enfermeiro&.authenticate(params[:password].to_s)
        payload = { sub: enfermeiro.id, exp: 30.minutes.from_now.to_i }
        token = JWT.encode(payload, Rails.application.credentials.jwt_secret || ENV["JWT_SECRET"], "HS256")

        render json: {
          mensagem: "Login realizado com sucesso",
          token: token,
          enfermeiro: enfermeiro.as_json(only: [ :id, :nome, :email, :cpf, :coren, :instituicao, :data_nascimento, :sexo, :uf ])
        }, status: :ok
      else
        render json: { erro: "Credenciais inválidas. Verifique seu identificador e senha." }, status: :unauthorized
      end
    end

    def validar_senha
      # Lógica para validar a senha
      identificador = params[:identificador].to_s.downcase.strip
      senha = params[:password]

      enfermeiro =
        Enfermeiro.find_by("LOWER(email) = ?", identificador) ||
        Enfermeiro.find_by(cpf: identificador) ||
        Enfermeiro.find_by("UPPER(REPLACE(coren, ' ', '')) = ?", identificador)

      if enfermeiro&.authenticate(senha)
        render json: { valido: true }, status: :ok
      else
        render json: { erro: "Senha incorreta" }, status: :unauthorized
      end
    end
  end
end

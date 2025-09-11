module Api
  class EnfermeirosController < ApplicationController
    skip_before_action :authenticate_request!, only: [ :create, :validar_coren, :validar_cpf, :validar_email ]

    # POST /api/enfermeiros
    def create
      enfermeiro = Enfermeiro.new(enfermeiro_params)

      if enfermeiro.save
        render json: { mensagem: "✅ Cadastro realizado com sucesso" }, status: :created
      else
        render json: { erro: enfermeiro.errors.full_messages.join(", ") }, status: :unprocessable_entity
      end
    end

    # POST /api/enfermeiros/validar_cpf
    def validar_cpf
      cpf = params[:cpf].to_s.gsub(/\D/, "")
      ja_existe = Enfermeiro.exists?(cpf: cpf)

      render json: {
        valido: !ja_existe,
        mensagem: ja_existe ? "❌ CPF já cadastrado!" : "✅ CPF disponível!"
      }
    end

    # POST /api/enfermeiros/validar_email
    def validar_email
      email = params[:email].to_s.strip.downcase
      ja_existe = Enfermeiro.exists?(email: email)

      render json: {
        valido: !ja_existe,
        mensagem: ja_existe ? "❌ E-mail já cadastrado!" : "✅ E-mail disponível!"
      }
    end

    # POST /api/enfermeiros/validar_coren
    def validar_coren
      coren = params[:coren].to_s.strip
      uf    = params[:uf].to_s.strip.upcase

      ja_existe = Enfermeiro.exists?(coren: coren, uf: uf)

      render json: {
        valido: !ja_existe,
        mensagem: ja_existe ? "❌ COREN já cadastrado!" : "✅ COREN disponível!"
      }
    end

    private

    def enfermeiro_params
      params.require(:enfermeiro).permit(:nome, :data_nascimento, :cpf, :sexo, :email, :coren, :uf, :instituicao, :password)
    end
  end
end

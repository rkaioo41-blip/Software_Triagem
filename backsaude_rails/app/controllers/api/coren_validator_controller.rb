# app/controllers/api/coren_validator_controller.rb
module Api
  class CorenValidatorController < ApplicationController
    # POST /api/validar_coren
    def validar
      coren = params[:coren]&.strip&.upcase
      uf = params[:uf]&.strip&.upcase

      # Valida campos obrigatórios
      if coren.blank?
        return render json: { erro: "Informe o COREN" }, status: :bad_request
      end

      if uf.blank?
        return render json: { erro: "Selecione a UF" }, status: :bad_request
      end

      # Regex para formato válido
      if coren.match?(/^\d{5,6}-ENF$/)
        numero = coren.split("-").first

        # Verifica se é sequencial (ex: 123456 ou 111111)
        if numero.chars.uniq.length == 1 || numero == "12345" || numero == "123456"
          return render json: { valido: false, mensagem: "COREN INVÁLIDO" }
        end

        render json: {
          valido: true,
          nome: "Enfermeiro(a) Simulado(a)",
          uf: uf
        }
      else
        render json: { valido: false, mensagem: "Formato inválido. Ex: 123456-ENF" }
      end
    end
  end
end

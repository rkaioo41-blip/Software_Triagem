module Api
  class PacientesFakeController < ApplicationController
    skip_before_action :authenticate_request!   # pula autenticação para esse controller

    def show
      paciente = PacienteFake.find_by(codigo_sus: params[:codigo_sus])
      if paciente
        render json: paciente
      else
        render json: { error: "Paciente não encontrado" }, status: :not_found
      end
    end
  end
end

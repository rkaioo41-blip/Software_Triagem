module Api
  class SinaisVitaisController < ApplicationController
    def create
      paciente = Paciente.find(params[:paciente_id])
      sinais_vitais = paciente.build_sinais_vitais(sinais_vitais_params)

      if sinais_vitais.save
        render json: sinais_vitais, status: :created
      else
        render json: { errors: sinais_vitais.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def sinais_vitais_params
      params.require(:sinais_vitais).permit(:pressao_arterial, :temperatura, :frequencia_cardiaca, :frequencia_respiratoria)
    end
  end
end

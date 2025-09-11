class Api::PacientesController < ApplicationController
  def create
    paciente = Paciente.new(paciente_params)

    if paciente.save
      render json: paciente, status: :created
    else
      render json: { errors: paciente.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def paciente_params
    params.require(:paciente).permit(
      :nome,
      :cpf,
      :sexo,
      :data_nascimento,
      :endereco,
      :cidade,
      :nome_pai,
      :nome_mae,
      :raca_cor,
      :informa_orientacao,
      :orientacao_sexual,
      :identidade_genero,
      :nome_social
    )
  end
end

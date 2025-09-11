class Api::MedicosController < ApplicationController
  def disponiveis
    hora = params[:hora].to_time

    medicos = Medico.where("hora_inicio <= ? AND hora_fim >= ?", hora, hora)

    render json: medicos.as_json(only: [ :id, :nome, :CRM, :especialidade, :hora_inicio, :hora_fim ])
  end

  # CRUD normal se quiser manter
  def index
    medicos = Medico.all
    render json: medicos
  end
end

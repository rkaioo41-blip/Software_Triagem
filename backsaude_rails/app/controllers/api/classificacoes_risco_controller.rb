# app/controllers/api/classificacoes_risco_controller.rb
module Api
  class ClassificacoesRiscoController < ApplicationController
    skip_before_action :authenticate_request!, only: [ :index ]

    def index
      @classificacoes = ClassificacaoRisco.all
      render json: @classificacoes
    end
  end
end

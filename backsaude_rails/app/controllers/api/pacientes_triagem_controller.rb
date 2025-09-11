module Api
  class PacientesTriagemController < ActionController::API
    before_action :set_paciente, only: [ :update, :destroy ]

    # GET /api/pacientes_triagem
    def index
      @pacientes = PacienteTriagem.all.order(created_at: :desc)
      render json: @pacientes
    end

    # POST /api/pacientes_triagem
    def create
      @paciente = PacienteTriagem.new(paciente_params)

      if @paciente.save
        render json: @paciente, status: :created
      else
        render json: { errors: @paciente.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PUT /api/pacientes_triagem/:id
    def update
      if @paciente.update(paciente_params)
        render json: @paciente
      else
        render json: { errors: @paciente.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/pacientes_triagem/:id
    def destroy
      @paciente.destroy
      head :no_content
    end

    private

    def set_paciente
      @paciente = PacienteTriagem.find(params[:id])
    end

    def paciente_params
      permitted_params = params.require(:paciente).permit(:codigo_sus, :nome, :data_nascimento, :cpf, :status)

      # Converter status string para o valor numérico do enum
      if permitted_params[:status].present?
        status_mapping = {
          "Aguardando" => "aguardando",
          "aguardando" => "aguardando",
          "Finalizada" => "finalizada",
          "finalizada" => "finalizada"
        }

        permitted_params[:status] = status_mapping[permitted_params[:status]]
      end

      permitted_params
    end
  end
end

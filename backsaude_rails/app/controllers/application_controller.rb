class ApplicationController < ActionController::API
  before_action :authenticate_request!

  def authenticate_request!
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    decoded = JsonWebToken.decode(header)
    @current_enfermeiro = Enfermeiro.find(decoded[:enfermeiro_id]) if decoded
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError
    render json: { erro: "Acesso não autorizado" }, status: :unauthorized
  end
end

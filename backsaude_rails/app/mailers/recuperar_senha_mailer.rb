class RecuperarSenhaMailer < ApplicationMailer
  default from: "naoresponder@localhost.com.br"

  # ✅ Método sem argumentos, usa params do mailer
  def instrucoes
    @enfermeiro = params[:enfermeiro]
    @token = params[:token]

    @url_redefinir = "#{ENV['FRONT_URL'] || 'http://localhost:8081'}/recuperar-senha?token=#{@token}"

    mail(to: @enfermeiro.email, subject: "Instruções para redefinir sua senha")
  end
end

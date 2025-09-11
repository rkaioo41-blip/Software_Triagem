module Api
  class RelatoriosTriagemController < ApplicationController
skip_before_action :authenticate_request!, only: [ :create, :download, :index, :estatisticas ]

  AES_KEY = begin
    raw = ENV["CHAVE_AES_256"]
    raise "❌ Variável CHAVE_AES_256 não definida no ENV" if raw.blank?
    key = [ raw ].pack("H*")
    raise "❌ Chave AES inválida: precisa ter 32 bytes, tem #{key.bytesize}" if key.bytesize != 32
    key
  end

  def index
    relatorios = RelatorioTriagem.includes(:paciente_fake, :enfermeiro, :classificacao_risco, :medico)
                                 .order(data_triagem: :desc)

    relatorios = relatorios.where(enfermeiro_id: params[:enfermeiro_id]) if params[:enfermeiro_id].present?
    relatorios = relatorios.where("data_triagem >= ?", params[:data_inicio]) if params[:data_inicio].present?
    relatorios = relatorios.where("data_triagem <= ?", params[:data_fim]) if params[:data_fim].present?

    render json: relatorios.map { |r|
      dados = r.dados || {}
      {
        id: r.id,
        protocolo: r.protocolo,
        data_triagem: r.data_triagem,
        paciente_fake: { id: r.paciente_fake_id, nome: r.paciente_fake&.nome },
        enfermeiro: { id: r.enfermeiro_id, nome: r.enfermeiro&.nome, coren: r.enfermeiro&.coren },
        medico: { id: r.medico_id, nome: r.medico&.nome, crm: r.medico&.CRM },
        classificacao_risco: { id: r.classificacao_risco_id, nome_nivel: r.classificacao_risco&.nome_nivel, nivel: r.classificacao_risco&.nivel },
        sinais_vitais: dados["sinais_vitais"],
        sintomas: dados["sintomas"],
        prioridades: dados["prioridades"],
        comorbidades: dados["comorbidades"],
        alergias: dados["alergias"],
        pdf_disponivel: r.pdf_data.present?
      }
    }
  end

  def estatisticas
    triagens = RelatorioTriagem.all

    if params[:enfermeiro_id].present?
      triagens = triagens.where(enfermeiro_id: params[:enfermeiro_id])
    end

    classificacoes = triagens.map(&:classificacao_risco_id).tally
    sintomas = triagens.flat_map { |t| t.dados.dig("sintomas", "selecionados") rescue [] }.compact.tally
    prioridades = triagens.flat_map { |t| t.dados["prioridades"] if t.dados }.compact.tally
    comorbidades = triagens.flat_map { |t| t.dados["comorbidades"] if t.dados }.compact.tally

    render json: {
      classificacoes: classificacoes,
      sintomas: sintomas,
      prioridades: prioridades,
      comorbidades: comorbidades
    }
  end

  def create
    begin
      Rails.logger.info "Params recebidos: #{params.inspect}"

      pdf_data = params.dig(:relatorio_triagem, :pdf_data)
      if pdf_data.present?
        # Reverte a inversão do frontend antes de criptografar
        base64_revertido = pdf_data.reverse
        params[:relatorio_triagem][:pdf_data] = criptografar_pdf(base64_revertido)
      end

      relatorio = RelatorioTriagem.new(relatorio_params)

      if relatorio.save
        render json: { id: relatorio.id, message: "Relatório salvo com sucesso!" }, status: :created
      else
        Rails.logger.error "Erros ao salvar relatório: #{relatorio.errors.full_messages}"
        render json: { errors: relatorio.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      Rails.logger.error "Erro no create: #{e.message}\n#{e.backtrace.join("\n")}"
      render json: { error: "Erro interno do servidor: #{e.message}" }, status: :internal_server_error
    end
  end

  def download
    relatorio = RelatorioTriagem.find(params[:id])
    if relatorio.pdf_data.present?
      begin
        pdf_bin = descriptografar_pdf(relatorio.pdf_data)

        # Converte para base64 e aplica inversão para o frontend reverter
        base64 = Base64.strict_encode64(pdf_bin)
        base64_invertido = base64.reverse

        # Envia como texto plano para o frontend converter para blob
        send_data base64_invertido,
                  filename: "Triagem_#{relatorio.protocolo}.txt",
                  type: "text/plain",
                  disposition: "inline"
      rescue => e
        Rails.logger.error "Erro ao processar PDF: #{e.message}"
        render json: { error: "Erro ao processar PDF: #{e.message}" }, status: :internal_server_error
      end
    else
      render json: { error: "PDF não disponível" }, status: :not_found
    end
  end

  private

  def relatorio_params
    params.require(:relatorio_triagem).permit(
      :paciente_fake_id,
      :enfermeiro_id,
      :medico_id,
      :classificacao_risco_id,
      :protocolo,
      :data_triagem,
      :pdf_data,
      :pdf_file_name,
      :pdf_content_type,
      :pdf_file_size,
      sinais_vitais: {},
      sintomas: {},
      prioridades: [],
      comorbidades: [],
      alergias: {}
    ).tap do |permitted|
      permitted[:dados] = {
        sinais_vitais: permitted[:sinais_vitais] || {},
        sintomas: permitted[:sintomas] || {},
        prioridades: permitted[:prioridades] || [],
        comorbidades: permitted[:comorbidades] || [],
        alergias: permitted[:alergias] || {}
      }
      permitted.delete(:sinais_vitais)
      permitted.delete(:sintomas)
      permitted.delete(:prioridades)
      permitted.delete(:comorbidades)
      permitted.delete(:alergias)
    end
  end

  def criptografar_pdf(pdf_data)
    # Decodifica base64 para binário antes de criptografar
    pdf_binario = Base64.decode64(pdf_data)

    cipher = OpenSSL::Cipher.new("aes-256-cbc")
    cipher.encrypt
    cipher.key = AES_KEY
    iv = cipher.random_iv
    cipher.iv = iv

    criptografado = cipher.update(pdf_binario) + cipher.final
    Base64.strict_encode64(iv + criptografado)
  end

  def descriptografar_pdf(pdf_criptografado_base64)
    dados = Base64.strict_decode64(pdf_criptografado_base64)
    iv = dados[0..15]
    criptografado = dados[16..-1]

    cipher = OpenSSL::Cipher.new("aes-256-cbc")
    cipher.decrypt
    cipher.key = AES_KEY
    cipher.iv = iv

    cipher.update(criptografado) + cipher.final
  end
  end
end

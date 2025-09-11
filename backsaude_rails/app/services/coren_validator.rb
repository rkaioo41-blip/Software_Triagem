require "net/http"
require "uri"
require "json"

class CorenValidator
  # Recebe número do COREN e UF
  def self.valid?(coren, uf)
    # Primeiro tenta API estadual
    dados = consulta_estado(coren, uf)

    # Se não houver resposta válida, tenta API nacional (Cofen)
    dados ||= consulta_nacional(coren)

    # Validação final: se existe e é enfermeiro ativo
    return false unless dados
    dados["categoria"] == "Enfermeiro" && dados["situacao"] == "Ativo"
  end

  private

  def self.consulta_estado(coren, uf)
    url = URI("https://servicos.coren-#{uf.downcase}.gov.br/api/consulta?numero=#{coren}")
    response = Net::HTTP.get_response(url)
    return nil unless response.is_a?(Net::HTTPSuccess)
    JSON.parse(response.body)
  rescue StandardError
    nil
  end

  def self.consulta_nacional(coren)
    url = URI("https://www.cofen.gov.br/api/enfermeiros/#{coren}")
    response = Net::HTTP.get_response(url)
    return nil unless response.is_a?(Net::HTTPSuccess)
    JSON.parse(response.body)
  rescue StandardError
    nil
  end
end

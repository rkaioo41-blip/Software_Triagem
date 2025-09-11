<template>
  <div class="politica-privacidade">
    <header class="cabecalho">
      <img src="@/assets/logo_sistema.png" alt="Logo TriaTech" class="logo">
      <h1>Política de Privacidade TriaTech</h1>
      <p class="versao">Versão 3.0 | Vigência: 28/06/2025</p>
    </header>

    <main class="conteudo">
      <section class="introducao">
        <p>O <strong>TriaTech - Sistema de Triagem Digital</strong>, desenvolvido pela HealthTech Solutions Ltda., está comprometido com a proteção dos dados de pacientes e profissionais de saúde. Esta política detalha como coletamos, processamos e protegemos as informações no contexto de triagem médica digital.</p>
      </section>

      <section>
        <h2><i class="fas fa-database icone"></i> 1. Dados Coletados</h2>
        
        <div class="dados-coletados">
          <div class="tipo-dados">
            <h3>Dados de Pacientes</h3>
            <ul>
              <li>Informações demográficas (idade, sexo)</li>
              <li>Sinais vitais e sintomas relatados</li>
              <li>Histórico médico relevante para triagem</li>
              <li>Classificação de risco (padrão Manchester)</li>
            </ul>
          </div>
          
          <div class="tipo-dados">
            <h3>Dados de Profissionais</h3>
            <ul>
              <li>Identificação profissional (CRM/COREN)</li>
              <li>Credenciais de acesso</li>
              <li>Registro de atividades no sistema</li>
              <li>Assinatura digital para validações</li>
            </ul>
          </div>
        </div>
      </section>

      <section>
        <h2><i class="fas fa-shield-alt icone"></i> 2. Medidas de Segurança</h2>
        <div class="medidas-seguranca">
          <div class="medida">
            <i class="fas fa-lock"></i>
            <h3>Criptografia</h3>
            <p>Todos os dados são criptografados em trânsito (TLS 1.3) e em repouso (AES-256)</p>
          </div>
          <div class="medida">
            <i class="fas fa-user-shield"></i>
            <h3>Controle de Acesso</h3>
            <p>Autenticação multifator e princípio do menor privilégio</p>
          </div>
          <div class="medida">
            <i class="fas fa-history"></i>
            <h3>Auditoria</h3>
            <p>Logs completos de acesso e modificações (padrão HIPAA)</p>
          </div>
        </div>
      </section>

      <section>
        <h2><i class="fas fa-chart-pie icone"></i> 3. Finalidades do Tratamento</h2>
        <ol class="finalidades">
          <li>Classificação de risco dos pacientes</li>
          <li>Priorização de atendimento</li>
          <li>Geração de indicadores epidemiológicos</li>
          <li>Melhoria contínua dos protocolos de triagem</li>
          <li>Integração com sistemas de prontuário eletrônico</li>
        </ol>
      </section>

      <section>
        <h2><i class="fas fa-exchange-alt icone"></i> 4. Compartilhamento de Dados</h2>
        <p>Os dados podem ser compartilhados exclusivamente com:</p>
        <table class="tabela-compartilhamento">
          <thead>
            <tr>
              <th>Destinatário</th>
              <th>Finalidade</th>
              <th>Base Legal</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Equipe médica</td>
              <td>Atendimento do paciente</td>
              <td>Legítimo interesse</td>
            </tr>
            <tr>
              <td>Órgãos de saúde</td>
              <td>Notificação compulsória</td>
              <td>Obrigação legal</td>
            </tr>
            <tr>
              <td>Pesquisadores</td>
              <td>Estudos epidemiológicos</td>
              <td>Dados anonimizados</td>
            </tr>
          </tbody>
        </table>
      </section>

      <section class="direitos-usuario">
        <h2><i class="fas fa-user-check icone"></i> 5. Direitos dos Titulares</h2>
        <div class="cartao-direitos">
          <div class="direito">
            <i class="fas fa-search"></i>
            <span>Acesso aos dados</span>
          </div>
          <div class="direito">
            <i class="fas fa-edit"></i>
            <span>Correção</span>
          </div>
          <div class="direito">
            <i class="fas fa-trash-alt"></i>
            <span>Exclusão</span>
          </div>
          <div class="direito">
            <i class="fas fa-file-export"></i>
            <span>Portabilidade</span>
          </div>
          <div class="direito">
            <i class="fas fa-ban"></i>
            <span>Revogação de consentimento</span>
          </div>
        </div>
        <p>Para exercer seus direitos, contate nosso Encarregado de Dados:</p>
        <a href="mailto:lgpd@triatech.health" class="botao-contato">
          <i class="fas fa-envelope"></i> lgpd@triatech.health
        </a>
      </section>

      <section class="disposicoes-finais">
        <h2><i class="fas fa-file-signature icone"></i> 6. Disposições Finais</h2>
        <p>Esta política está em conformidade com:</p>
        <ul>
          <li>Lei Geral de Proteção de Dados (LGPD - Lei 13.709/18)</li>
          <li>Resoluções do CFM sobre telemedicina</li>
          <li>Normativas do Ministério da Saúde</li>
        </ul>
        <p class="atualizacao">Última atualização: 28/06/2025</p>
      </section>
    </main>
  </div>
</template>

<script>
export default {
  name: 'PoliticaPrivacidadeTriaTech',
  data() {
    return {
      versaoAtual: '3.0',
      dataVigencia: '28/06/2025'
    }
  },
  mounted() {
    document.title = 'Política de Privacidade - TriaTech'
  }
}
</script>

<style scoped>
.politica-privacidade {
  max-width: 1000px;
  margin: 0 auto;
  padding: 2rem;
  font-family: 'Roboto', sans-serif;
  color: #333;
  line-height: 1.6;
}

.cabecalho {
  text-align: center;
  margin-bottom: 2rem;
  padding-bottom: 1.5rem;
  border-bottom: 2px solid #0066cc;
}

.cabecalho h1 {
  color: #0066cc;
  font-size: 2rem;
  margin: 1rem 0 0.5rem;
}

.logo {
  height: 80px;
  margin-bottom: 1rem;
}

.versao {
  color: #666;
  font-weight: 500;
  font-size: 0.9rem;
}

.conteudo {
  background-color: #fff;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

h2 {
  color: #0066cc;
  font-size: 1.4rem;
  margin: 2rem 0 1rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid #e0e0e0;
  display: flex;
  align-items: center;
}

.icone {
  margin-right: 10px;
  font-size: 1.2rem;
}

.dados-coletados {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2rem;
  margin: 1.5rem 0;
}

.tipo-dados {
  background-color: #f5f9ff;
  padding: 1.2rem;
  border-radius: 6px;
  border-left: 4px solid #0066cc;
}

.tipo-dados h3 {
  color: #0066cc;
  margin-top: 0;
  margin-bottom: 0.8rem;
}

.medidas-seguranca {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin: 1.5rem 0;
}

.medida {
  text-align: center;
  padding: 1.5rem;
  background-color: #f8f8f8;
  border-radius: 8px;
  transition: transform 0.3s;
}

.medida:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0,102,204,0.1);
}

.medida i {
  font-size: 2rem;
  color: #0066cc;
  margin-bottom: 1rem;
}

.finalidades {
  background-color: #f5f9ff;
  padding: 1.5rem 1.5rem 1.5rem 2.5rem;
  border-radius: 8px;
}

.tabela-compartilhamento {
  width: 100%;
  border-collapse: collapse;
  margin: 1.5rem 0;
}

.tabela-compartilhamento th, 
.tabela-compartilhamento td {
  padding: 12px 15px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

.tabela-compartilhamento th {
  background-color: #0066cc;
  color: white;
}

.tabela-compartilhamento tr:nth-child(even) {
  background-color: #f5f9ff;
}

.cartao-direitos {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  margin: 1.5rem 0;
}

.direito {
  flex: 1;
  min-width: 150px;
  background-color: #0066cc;
  color: white;
  padding: 1rem;
  border-radius: 6px;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.direito i {
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
}

.botao-contato {
  display: inline-flex;
  align-items: center;
  background-color: #0066cc;
  color: white;
  padding: 0.8rem 1.5rem;
  border-radius: 6px;
  text-decoration: none;
  margin-top: 1rem;
  transition: background-color 0.3s;
}

.botao-contato:hover {
  background-color: #0052a3;
}

.botao-contato i {
  margin-right: 8px;
}

.disposicoes-finais {
  background-color: #f5f9ff;
  padding: 1.5rem;
  border-radius: 8px;
  margin-top: 2rem;
}

.atualizacao {
  text-align: right;
  font-style: italic;
  color: #666;
  margin-top: 2rem;
}

@media (max-width: 768px) {
  .dados-coletados {
    grid-template-columns: 1fr;
  }
  
  .politica-privacidade {
    padding: 1rem;
  }
  
  .conteudo {
    padding: 1rem;
  }
}
</style>
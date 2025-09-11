<template>
  <div class="termos-uso-container">
    <header class="cabecalho-termos">
      <img src="@/assets/logo_sistema.png" alt="Logo TriaTech" class="logo-termos">
      <h1>Termos de Uso do TriaTech</h1>
      <p class="versao-termos">Versão 2.0 | Vigência: 28/06/2025</p>
    </header>

    <main class="conteudo-termos">
      <section class="introducao-termos">
        <p>Estes Termos de Uso regulamentam a utilização do <strong>TriaTech - Sistema de Triagem Digital</strong>, desenvolvido pela HealthTech Solutions Ltda. (CNPJ: 12.345.678/0001-99). Ao acessar o sistema, você concorda com estes termos na íntegra.</p>
      </section>

      <section>
        <h2><i class="fas fa-check-circle icone-termo"></i> 1. Aceitação dos Termos</h2>
        <p>1.1. O uso do TriaTech está condicionado à aceitação integral destes Termos de Uso e da Política de Privacidade.</p>
        <p>1.2. Profissionais de saúde devem confirmar seu registro no conselho de classe correspondente para acesso pleno ao sistema.</p>
      </section>

      <section>
        <h2><i class="fas fa-user-md icone-termo"></i> 2. Uso Autorizado</h2>
        <p>2.1. O TriaTech destina-se exclusivamente a:</p>
        <ul class="lista-termos">
          <li>Classificação de risco de pacientes</li>
          <li>Priorização de atendimentos em serviços de saúde</li>
          <li>Registro de dados clínicos essenciais para triagem</li>
        </ul>
        <p>2.2. É vedado qualquer uso que:</p>
        <ul class="lista-termos">
          <li>Infrinja códigos de ética profissional</li>
          <li>Comprometa a segurança dos dados</li>
          <li>Descumpra protocolos clínicos estabelecidos</li>
        </ul>
      </section>

      <section>
        <h2><i class="fas fa-key icone-termo"></i> 3. Credenciais de Acesso</h2>
        <p>3.1. Cada usuário receberá credenciais individuais e intransferíveis.</p>
        <p>3.2. O usuário é integralmente responsável por:</p>
        <div class="responsabilidades-grid">
          <div class="responsabilidade-item">
            <i class="fas fa-lock"></i>
            <p>Manter a confidencialidade da senha</p>
          </div>
          <div class="responsabilidade-item">
            <i class="fas fa-bell"></i>
            <p>Notificar imediatamente sobre acesso não autorizado</p>
          </div>
          <div class="responsabilidade-item">
            <i class="fas fa-sign-out-alt"></i>
            <p>Encerrar a sessão ao final do uso</p>
          </div>
        </div>
      </section>

      <section>
        <h2><i class="fas fa-gavel icone-termo"></i> 4. Responsabilidades</h2>
        <p>4.1. O TriaTech é uma ferramenta de apoio à decisão clínica, não substituindo o julgamento profissional.</p>
        <p>4.2. O profissional de saúde assume total responsabilidade:</p>
        <ul class="lista-termos">
          <li>Pelas classificações de risco realizadas</li>
          <li>Pela veracidade dos dados inseridos</li>
          <li>Pelo cumprimento dos protocolos institucionais</li>
        </ul>
      </section>

      <section>
        <h2><i class="fas fa-ban icone-termo"></i> 5. Condutas Proibidas</h2>
        <div class="alertas-termos">
          <div class="alerta-termo alerta-gravissimo">
            <i class="fas fa-skull-crossbones"></i>
            <p>Falsificação de credenciais profissionais</p>
          </div>
          <div class="alerta-termo alerta-grave">
            <i class="fas fa-exclamation-triangle"></i>
            <p>Modificação não autorizada de registros</p>
          </div>
          <div class="alerta-termo alerta-medio">
            <i class="fas fa-user-secret"></i>
            <p>Acesso a dados sem necessidade clínica</p>
          </div>
        </div>
        <p>Violar estas normas acarretará suspensão imediata do acesso e medidas legais cabíveis.</p>
      </section>

      <section>
        <h2><i class="fas fa-shield-alt icone-termo"></i> 6. Propriedade Intelectual</h2>
        <p>6.1. Todo o conteúdo do sistema, incluindo algoritmos de triagem, interfaces e documentos, é propriedade da HealthTech Solutions.</p>
        <p>6.2. Os dados clínicos inseridos permanecem sob custódia da instituição de saúde responsável pelo paciente.</p>
      </section>

      <section>
        <h2><i class="fas fa-exchange-alt icone-termo"></i> 7. Modificações</h2>
        <p>7.1. Estes termos podem ser atualizados periodicamente para refletir:</p>
        <ul class="lista-termos">
          <li>Mudanças regulatórias na área de saúde</li>
          <li>Atualizações de funcionalidades do sistema</li>
          <li>Requisitos de segurança da informação</li>
        </ul>
        <p>7.2. Alterações significativas serão comunicadas com 30 dias de antecedência.</p>
      </section>

      <section class="disposicoes-finais-termos">
        <h2><i class="fas fa-balance-scale icone-termo"></i> 8. Disposições Finais</h2>
        <p>8.1. Casos omissos serão resolvidos conforme a legislação brasileira.</p>
        <p>8.2. Dúvidas devem ser encaminhadas para: <a href="mailto:juridico@triatech.health">juridico@triatech.health</a></p>
        <div class="selo-conformidade">
          <i class="fas fa-certificate"></i>
          <span>Sistema registrado na ANVISA sob nº 12345.67890/2025</span>
        </div>
      </section>

      <footer class="rodape-termos">
        <p class="atualizacao-termos">Última revisão: 28 de junho de 2025</p>
        <p class="copyright-termos">© 2025 HealthTech Solutions Ltda. Todos os direitos reservados.</p>
      </footer>
    </main>
  </div>
</template>

<script>
export default {
  name: 'TermosUsoTriaTech',
  data() {
    return {
      versaoTermos: '2.0',
      dataVigencia: '28/06/2025'
    }
  },
  mounted() {
    document.title = 'Termos de Uso - TriaTech'
  }
}
</script>

<style scoped>
.termos-uso-container {
  max-width: 1000px;
  margin: 0 auto;
  padding: 2rem;
  font-family: 'Roboto', sans-serif;
  color: #333;
  line-height: 1.6;
}

.cabecalho-termos {
  text-align: center;
  margin-bottom: 2rem;
  padding-bottom: 1.5rem;
  border-bottom: 2px solid #2a7f62;
}

.cabecalho-termos h1 {
  color: #2a7f62;
  font-size: 2rem;
  margin: 1rem 0 0.5rem;
}

.logo-termos {
  height: 80px;
  margin-bottom: 1rem;
}

.versao-termos {
  color: #666;
  font-weight: 500;
  font-size: 0.9rem;
}

.conteudo-termos {
  background-color: #fff;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

h2 {
  color: #2a7f62;
  font-size: 1.4rem;
  margin: 2rem 0 1rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid #e0e0e0;
  display: flex;
  align-items: center;
}

.icone-termo {
  margin-right: 10px;
  font-size: 1.2rem;
}

.lista-termos {
  padding-left: 1.5rem;
}

.lista-termos li {
  margin-bottom: 0.5rem;
  position: relative;
}

.lista-termos li:before {
  content: "•";
  color: #2a7f62;
  font-weight: bold;
  display: inline-block;
  width: 1em;
  margin-left: -1em;
}

.responsabilidades-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin: 1.5rem 0;
}

.responsabilidade-item {
  background-color: #f0f7f4;
  padding: 1.2rem;
  border-radius: 8px;
  text-align: center;
  transition: transform 0.3s;
}

.responsabilidade-item:hover {
  transform: translateY(-3px);
  box-shadow: 0 3px 10px rgba(42,127,98,0.1);
}

.responsabilidade-item i {
  color: #2a7f62;
  font-size: 1.5rem;
  margin-bottom: 0.8rem;
}

.alertas-termos {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  margin: 1.5rem 0;
}

.alerta-termo {
  flex: 1;
  min-width: 200px;
  padding: 1rem;
  border-radius: 6px;
  display: flex;
  align-items: center;
  font-weight: 500;
}

.alerta-termo i {
  margin-right: 10px;
  font-size: 1.2rem;
}

.alerta-gravissimo {
  background-color: #ffebee;
  color: #c62828;
  border-left: 4px solid #c62828;
}

.alerta-grave {
  background-color: #fff8e1;
  color: #f57f17;
  border-left: 4px solid #f57f17;
}

.alerta-medio {
  background-color: #e8f5e9;
  color: #2e7d32;
  border-left: 4px solid #2e7d32;
}

.disposicoes-finais-termos {
  background-color: #f0f7f4;
  padding: 1.5rem;
  border-radius: 8px;
  margin-top: 2rem;
}

.selo-conformidade {
  display: inline-flex;
  align-items: center;
  background-color: #e8f5e9;
  color: #2e7d32;
  padding: 0.8rem 1.2rem;
  border-radius: 20px;
  margin-top: 1rem;
}

.selo-conformidade i {
  margin-right: 8px;
  color: #2e7d32;
}

.rodape-termos {
  text-align: center;
  margin-top: 3rem;
  padding-top: 1.5rem;
  border-top: 1px solid #e0e0e0;
}

.atualizacao-termos {
  font-style: italic;
  color: #666;
}

.copyright-termos {
  color: #666;
  font-size: 0.9rem;
  margin-top: 0.5rem;
}

@media (max-width: 768px) {
  .termos-uso-container {
    padding: 1rem;
  }
  
  .conteudo-termos {
    padding: 1rem;
  }
  
  .responsabilidades-grid {
    grid-template-columns: 1fr;
  }
}
</style>
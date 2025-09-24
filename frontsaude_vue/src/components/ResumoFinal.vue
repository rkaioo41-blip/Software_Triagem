<template>
  <div>
    <div class="relatorio-container" ref="relatorioRef">
      <!-- Cabeçalho institucional -->
      <header class="cabecalho-institucional">
        <div class="logo-container">
          <img src="@/assets/logo_sistema.png" alt="Logo Sistema" class="logo" />
        </div>
        <div class="instituicao-info">
          <div class="instituicao-titulo">
            <h1>{{ dados.enfermeiro.instituicao?.toUpperCase() || 'INSTITUIÇÃO NÃO INFORMADA' }}</h1>
          </div>
          <p class="documento-tipo">RELATÓRIO DE TRIAGEM</p>
        </div>
        <div class="documento-metadata">
          <p><strong>Protocolo:</strong> {{ protocoloCompleto }}</p>
          <p><strong>Data:</strong> {{ dataAtualFormatada }}</p>
        </div>
      </header>

      <h2 class="titulo-documento">RELATÓRIO DE TRIAGEM</h2>

      <!-- Classificação de Risco -->
      <div class="dados-principais" :style="{ backgroundColor: corClassificacao }">
        <div class="classificacao-risco">
          <h3>CLASSIFICAÇÃO DE RISCO: {{ (dados.classificacao.nivel || '').toUpperCase() || '—' }}</h3>
          <p><strong>Prioridade:</strong> {{ dados.classificacao.descricao || '—' }}</p>
          <p><strong>Tempo Máx. Espera:</strong> {{ tempoAtendimento }}</p>
          <p><strong>Data/Hora:</strong> {{ formatarDataHora(dados.classificacao.dataClassificacao) }}</p>
        </div>
        <div class="profissional-responsavel">
          <h3>PROFISSIONAL RESPONSÁVEL</h3>
          <p><strong>Enfermeiro(a):</strong> {{ dados.enfermeiro.nome || '—' }}</p>
          <p><strong>COREN:</strong> {{ dados.enfermeiro.coren || '—' }}</p>
        </div>
      </div>

      <!-- Dados do Paciente -->
      <div class="dados-paciente">
        <h3>DADOS DO PACIENTE</h3>
        <div class="dados-grid">
          <div>
            <p><strong>Nome:</strong> {{ dados.paciente.nome || 'Não informado' }}</p>
            <p><strong>Data Nasc.:</strong> {{ formatarData(dados.paciente.data_nascimento) }}</p>
            <p><strong>Idade:</strong> {{ calcularIdade(dados.paciente.data_nascimento) }}</p>
            <p><strong>Sexo:</strong> {{ formatarSexo(dados.paciente.sexo) }}</p>
            <p><strong>Raça/Cor:</strong> {{ dados.paciente.racaCor || 'Não informado' }}</p>
          </div>
          <div>
            <p><strong>CPF:</strong> {{ formatarCPF(dados.paciente.cpf) || 'Não informado' }}</p>
            <p><strong>RG:</strong> {{ dados.paciente.rg || 'Não informado' }}</p>
            <p><strong>CNS:</strong> {{ dados.paciente.cns || 'Não informado' }}</p>
            <p><strong>Cidade:</strong> {{ dados.paciente.cidade || 'Não informada' }}</p>
            <p><strong>UF:</strong> {{ dados.paciente.uf || 'Não informado' }}</p>
          </div>
          <div>
            <p><strong>Telefone:</strong> {{ formatarTelefone(dados.paciente.telefone) || 'Não informado' }}</p>
            <p><strong>E-mail:</strong> {{ dados.paciente.email || 'Não informado' }}</p>
            <p><strong>Nome da Mãe:</strong> {{ dados.paciente.nomeMae || 'Não informado' }}</p>
            <p><strong>Nome do Pai:</strong> {{ dados.paciente.nomePai || 'Não informado' }}</p>
            <p><strong>Nome Social:</strong> {{ dados.paciente.nomeSocial || 'Não informado' }}</p>
          </div>
        </div>
      </div>

      <!-- Sinais Vitais -->
      <div class="sinais-vitais">
        <h3>SINAIS VITAIS</h3>
        <div class="sinais-grid">
          <div>
            <p><strong>Temperatura:</strong> {{ dados.sinaisVitais.temperatura || '--' }} °C</p>
            <p><strong>Frequência Cardíaca:</strong> {{ dados.sinaisVitais.frequenciaCardiaca || '--' }} bpm</p>
          </div>
          <div>
            <p><strong>Pressão Arterial:</strong> {{ dados.sinaisVitais.pressaoArterial || '--/--' }} mmHg</p>
            <p><strong>Frequência Respiratória:</strong> {{ dados.sinaisVitais.frequenciaRespiratoria || '--' }} rpm</p>
          </div>
          <div>
            <p><strong>Saturação:</strong> {{ dados.sinaisVitais.saturacao || '--' }} %</p>
            <p><strong>Glicemia:</strong> {{ dados.sinaisVitais.glicemia || '--' }} mg/dL</p>
          </div>
        </div>
        <p class="data-medicao" v-if="dados.sinaisVitais.medidaEm">
          <small>Medidos em: {{ formatarDataHora(dados.sinaisVitais.medidaEm) }}</small>
        </p>
      </div>

      <!-- Escala de Dor -->
      <div class="secao-relatorio">
        <h3>ESCALA DE DOR</h3>
        <div class="campo-resposta">
          <span class="rotulo-resposta">Intensidade:</span>
          <span class="valor-resposta">{{ escalaDorTexto }}</span>
        </div>
        <div class="escala-dor-visual">
          <div class="escala-dor-bar">
            <div class="escala-dor-fill" :style="{ width: escalaDorPorcentagem }"></div>
          </div>
          <div class="escala-dor-labels">
            <span>0</span>
            <span>5</span>
            <span>10</span>
          </div>
        </div>
        <p class="descricao-escala">
          <small>(0 = sem dor, 10 = pior dor possível)</small>
        </p>
      </div>

      <div class="secao-relatorio glasgow">
        <h3>ESCALA DE GLASGOW</h3>
        <div class="glasgow-grid">
          <div>
            <p><strong>Abertura Ocular:</strong> {{ dados.sinaisVitais.glasgowOcular || '--' }}</p>
            <p><strong>Resposta Verbal:</strong> {{ dados.sinaisVitais.glasgowVerbal || '--' }}</p>
            <p><strong>Resposta Motora:</strong> {{ dados.sinaisVitais.glasgowMotora || '--' }}</p>
          </div>
          <div>
            <p class="total-glasgow"><strong>Total Glasgow:</strong> {{ calcularTotalGlasgow() || '--' }}</p>
            <div class="interpretacao-glasgow">
              <small v-if="calcularTotalGlasgow() >= 13">Interpretação: Leve</small>
              <small v-else-if="calcularTotalGlasgow() >= 9">Interpretação: Moderado</small>
              <small v-else-if="calcularTotalGlasgow() >= 3">Interpretação: Grave</small>
            </div>
          </div>
        </div>
      </div>

      <!-- Sintomas -->
      <div class="secao-relatorio">
        <h3>SINTOMAS RELATADOS</h3>
        <div v-if="dados.sintomas.selecionados && dados.sintomas.selecionados.length > 0" class="lista-itens">
          <div v-for="(sintoma, i) in dados.sintomas.selecionados" :key="`sint-${i}`" class="item-lista">
            <span>{{ formatarSintoma(sintoma) }}</span>
          </div>
        </div>
        <p v-else class="nenhum-dado">Nenhum sintoma relatado.</p>
      </div>

      <!-- Outros Sintomas -->
      <div class="secao-relatorio" v-if="dados.sintomas.outrosSintomas">
        <h3>OUTROS SINTOMAS RELATADOS</h3>
        <div class="campo-resposta">
          <span class="valor-resposta">{{ dados.sintomas.outrosSintomas }}</span>
        </div>
      </div>

      <!-- Observações Clínicas -->
      <div class="secao-relatorio" v-if="dados.sintomas.observacoesClinicas">
        <h3>OBSERVAÇÕES CLÍNICAS</h3>
        <div class="campo-resposta">
          <span class="valor-resposta">{{ dados.sintomas.observacoesClinicas }}</span>
        </div>
      </div>

      <!-- Alergias -->
      <div class="secao-relatorio">
        <h3>ALERGIAS</h3>
        <div class="campo-resposta">
          <span class="valor-resposta">{{ dados.alergias.possuiAlergia ? 'Sim' : 'Não' }}</span>
        </div>
        <div v-if="dados.alergias.possuiAlergia" class="campo-resposta">
          <span class="rotulo-resposta">Descrição:</span>
          <span class="valor-resposta">{{ dados.alergias.descricao || 'Alergia não especificada' }}</span>
        </div>
      </div>

      <!-- Prioridades -->
      <div class="secao-relatorio">
        <h3>PRIORIDADES CLÍNICAS</h3>
        <div v-if="dados.prioridades && dados.prioridades.length" class="lista-itens">
          <div v-for="(item, i) in dados.prioridades" :key="`pri-${i}`" class="item-lista prioridade">
            <span>{{ formatarPrioridade(item) }}</span>
          </div>
        </div>
        <p v-else class="nenhum-dado">Nenhuma prioridade identificada.</p>
      </div>

      <!-- Comorbidades -->
      <div class="secao-relatorio">
        <h3>COMORBIDADES</h3>
        <div v-if="dados.comorbidades && dados.comorbidades.length" class="lista-itens">
          <div v-for="(item, i) in dados.comorbidades" :key="`com-${i}`" class="item-lista comorbidade">
            <span>{{ formatarComorbidade(item) }}</span>
          </div>
        </div>
        <p v-else class="nenhum-dado">Nenhuma comorbidade identificada.</p>
      </div>

      <!-- Rodapé -->
      <footer class="rodape">
        <p class="instituicao-rodape">{{ dados.enfermeiro.instituicao || 'INSTITUIÇÃO NÃO INFORMADA' }}</p>
        <div class="info-rodape">
          <p>Documento gerado em: {{ dataAtualFormatada }}</p>
          <p>Protocolo: {{ protocoloCompleto }}</p>
        </div>
        <p class="aviso-rodape">Este é um documento oficial válido apenas com o código de verificação</p>
      </footer>
    </div>

    <div class="botoes-acao">
      <button class="botao-enviar" @click="abrirModalMedicos" :disabled="enviando">
        <i class="fas fa-paper-plane"></i> {{ enviando ? 'Enviando...' : 'Enviar para o Médico' }}
      </button>
    </div>

    <!-- Modal de seleção de médico -->
    <div v-if="showModalMedicos" class="modal-overlay">
      <div class="modal modal-medicos">
        <div class="modal-header">
          <h3>Selecionar Médico</h3>
          <button class="modal-close" @click="showModalMedicos = false">
            <i class="fas fa-times"></i>
          </button>
        </div>
        <div class="modal-body">
          <p>Selecione o médico para enviar o relatório de triagem:</p>
          
          <div class="medicos-lista" v-if="medicosDisponiveis.length > 0">
            <div 
              v-for="medico in medicosDisponiveis" 
              :key="medico.id" 
              class="medico-item"
              :class="{ selecionado: medicoSelecionado && medicoSelecionado.id === medico.id }"
              @click="selecionarMedico(medico)"
            >
              <div class="medico-info">
                <h4>{{ medico.nome }}</h4>
                <p>CRM: {{ medico.CRM }} | {{ medico.especialidade }}</p>
                <p>Disponível das {{ formatarHora(medico.hora_inicio) }} às {{ formatarHora(medico.hora_fim) }}</p>
              </div>
              <div class="medico-selecao">
                <i v-if="medicoSelecionado && medicoSelecionado.id === medico.id" class="fas fa-check-circle"></i>
              </div>
            </div>
          </div>
          
          <div v-else class="nenhum-medico">
            <p>Nenhum médico disponível no momento.</p>
            <p>Tente novamente em alguns minutos.</p>
          </div>
        </div>
        <div class="modal-footer">
          <button @click="showModalMedicos = false">Cancelar</button>
          <button 
            @click="enviarParaMedico" 
            :disabled="!medicoSelecionado || enviando"
            class="btn-confirmar"
          >
            {{ enviando ? 'Enviando...' : 'Confirmar Envio' }}
          </button>
        </div>
      </div>
    </div>

    <!-- Modal de confirmação -->
    <div v-if="showModalConfirmacao" class="modal-overlay">
      <div class="modal">
        <div class="modal-header">
          <h3>Relatório Enviado com Sucesso!</h3>
        </div>
        <div class="modal-body">
          <p>O relatório de triagem foi enviado para o médico responsável.</p>
          <p><strong>Médico:</strong> {{ medicoSelecionado.nome }}</p>
          <p><strong>Protocolo:</strong> {{ protocoloCompleto }}</p>
          <p><strong>Paciente:</strong> {{ dados.paciente.nome || 'Não informado' }}</p>
          <p><strong>Classificação:</strong> {{ (dados.classificacao.nivel || '').toUpperCase() }}</p>
        </div>
        <div class="modal-footer">
          <button @click="redirecionarParaNovaTriagem">Iniciar Nova Triagem</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { computed, ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useTriagem } from '@/stores/triagem'
import html2pdf from 'html2pdf.js'
import axios from 'axios'
import { formatarSintoma, formatarPrioridade, formatarComorbidade } from '@/utilitarios/formatadores'

export default {
  name: 'ResumoFinal',
  setup() {
    const triagem = useTriagem()
    const router = useRouter()
    const relatorioRef = ref(null)
    const enviando = ref(false)
    const showModalMedicos = ref(false)
    const showModalConfirmacao = ref(false)
    const medicosDisponiveis = ref([])
    const medicoSelecionado = ref(null)

    onMounted(() => {
      triagem.carregarEnfermeiroLogado()
      const pSalvo = JSON.parse(localStorage.getItem('paciente_selecionado') || 'null')
      if (!triagem.paciente?.id && pSalvo?.id) triagem.setPaciente(pSalvo)
    })

    // Função para gerar código de verificação alfanumérico
    const gerarCodigoVerificacao = () => {
      const caracteres = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
      let codigo = ''
      for (let i = 0; i < 4; i++) {
        codigo += caracteres.charAt(Math.floor(Math.random() * caracteres.length))
      }
      return codigo
    }

    // Função para extrair iniciais do nome do enfermeiro
    const extrairIniciais = (nomeCompleto) => {
      if (!nomeCompleto) return 'ENF'
      const nomes = nomeCompleto.split(' ')
      if (nomes.length === 1) return nomes[0].substring(0, 3).toUpperCase()
      return (nomes[0].substring(0, 1) + nomes[nomes.length - 1].substring(0, 1)).toUpperCase()
    }

    // Novo protocolo: 52 (GO) + últimos 4 dígitos CPF + iniciais enfermeiro + hora + código verificação
    const protocoloCompleto = computed(() => {
      const now = new Date()
      const hora = `${String(now.getHours()).padStart(2, '0')}${String(now.getMinutes()).padStart(2, '0')}`
      
      // Últimos 4 dígitos do CPF
      const cpf = triagem.paciente?.cpf || ''
      const ultimos4CPF = cpf.length >= 4 ? cpf.slice(-4) : '0000'
      
      // Iniciais do enfermeiro
      const iniciaisEnf = extrairIniciais(triagem.enfermeiro?.nome)
      
      // Código de verificação
      const codigoVerificacao = gerarCodigoVerificacao()
      
      return `52${ultimos4CPF}${iniciaisEnf}${hora}${codigoVerificacao}`
    })

    const dataAtualFormatada = computed(() => {
      return new Date().toLocaleString('pt-BR', { day:'2-digit', month:'2-digit', year:'numeric', hour:'2-digit', minute:'2-digit' })
    })

    const tempoAtendimento = computed(() => {
      const tempo = dados.value.classificacao?.tempoAtendimento || 
                   dados.value.classificacao?.tempo_atendimento
      if (tempo) return tempo
      
      const nivel = dados.value.classificacao?.nivel
      const temposFallback = {
        vermelho: 'Atendimento imediato',
        laranja: 'Até 10 minutos',
        amarelo: 'Até 50 minutos', 
        verde: 'Até 120 minutos',
        azul: 'Até 240 minutos'
      }
      return temposFallback[nivel] || '—'
    })

    const formatarData = data => !data ? '--/--/----' : new Date(data).toLocaleDateString('pt-BR')
    const formatarDataHora = data => !data ? '--/--/---- --:--' : new Date(data).toLocaleString('pt-BR', { day:'2-digit', month:'2-digit', year:'numeric', hour:'2-digit', minute:'2-digit' })
    const formatarHora = hora => {
      if (!hora) return '--:--'
      const date = new Date(hora)
      return date.toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' })
    }
    const calcularIdade = dataNascimento => {
      if (!dataNascimento) return '--'
      const nascimento = new Date(dataNascimento)
      const hoje = new Date()
      let idade = hoje.getFullYear() - nascimento.getFullYear()
      const mes = hoje.getMonth() - nascimento.getMonth()
      if (mes < 0 || (mes===0 && hoje.getDate() < nascimento.getDate())) idade--
      return `${idade} anos`
    }
    const formatarSexo = sexo => !sexo ? 'Não informado' : (sexo==='M'?'Masculino':sexo==='F'?'Feminino':sexo)
    const formatarCPF = cpf => !cpf ? null : cpf.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4')
    const formatarTelefone = tel => {
      if (!tel) return null
      const nums = tel.replace(/\D/g,'')
      if (nums.length===11) return nums.replace(/(\d{2})(\d{5})(\d{4})/, '($1) $2-$3')
      if (nums.length===10) return nums.replace(/(\d{2})(\d{4})(\d{4})/, '($1) $2-$3')
      return tel
    }

    const corClassificacao = computed(() => {
      const cor = (triagem.classificacao?.nivel || '').toLowerCase()
      const cores = { vermelho:'#ffcccc', laranja:'#ffe0b2', amarelo:'#fff9c4', verde:'#c8e6c9', azul:'#e3f2fd' }
      return cores[cor] || '#f5f5f5'
    })

    const calcularTotalGlasgow = () => {
      const o = Number(triagem.sinaisVitais?.glasgowOcular) || 0
      const v = Number(triagem.sinaisVitais?.glasgowVerbal) || 0
      const m = Number(triagem.sinaisVitais?.glasgowMotora) || 0
      return o + v + m
    }

    const escalaDorTexto = computed(() => {
      const valor = triagem.sinaisVitais?.escalaDor
      if (valor === undefined || valor === null || valor === '') return '--'
      const n = Number(valor)
      if (Number.isNaN(n)) return '--'
      let desc = 'Dor leve'
      if (n >= 4 && n <= 6) desc = 'Dor moderada'
      else if (n >= 7 && n <= 10) desc = 'Dor intensa'
      return `${n}/10 — ${desc}`
    })
    
    const escalaDorPorcentagem = computed(() => {
      const valor = triagem.sinaisVitais?.escalaDor
      if (valor === undefined || valor === null || valor === '') return '0%'
      const n = Number(valor)
      if (Number.isNaN(n)) return '0%'
      return `${(n / 10) * 100}%`
    })

    const abrirModalMedicos = async () => {
      try {
        // Buscar médicos disponíveis
        const horaAtual = new Date().toTimeString().split(' ')[0].substring(0, 5) // Formato HH:MM
        const response = await axios.get(`http://localhost:3001/api/medicos/disponiveis?hora=${horaAtual}`, {
          headers: {
            'Authorization': `Bearer ${localStorage.getItem('authToken')}`
          }
        })
        
        medicosDisponiveis.value = response.data
        medicoSelecionado.value = null
        showModalMedicos.value = true
      } catch (error) {
        console.error('Erro ao buscar médicos disponíveis:', error)
        alert('Erro ao buscar médicos disponíveis. Tente novamente.')
      }
    }

    const selecionarMedico = (medico) => {
      medicoSelecionado.value = medico
    }

    const enviarParaMedico = async () => {
      if (!medicoSelecionado.value) {
        alert('Selecione um médico para enviar o relatório.')
        return
      }

      enviando.value = true
      try {
        // Gera o PDF primeiro
        const pdfData = await gerarPDF()
        
        // Salva o relatório com o PDF (apenas uma vez)
        await salvarRelatorioCompleto(pdfData)
        
        // Fecha o modal de médicos e abre o de confirmação
        showModalMedicos.value = false
        showModalConfirmacao.value = true
        
      } catch (error) {
        console.error('Erro ao enviar para médico:', error)
        alert('Erro ao enviar relatório para o médico. Tente novamente.')
      } finally {
        enviando.value = false
      }
    }

    const gerarPDF = async () => {
      try {
        const element = relatorioRef.value
        const opt = {
          margin: [15, 10, 15, 10],
          filename: `Relatorio_Triagem_${protocoloCompleto.value}.pdf`,
          image: { type: 'jpeg', quality: 0.98 },
          html2canvas: { 
            scale: 2, 
            letterRendering: true, 
            useCORS: true,
            onclone: (clonedDoc) => {
              const sections = clonedDoc.querySelectorAll('.secao-relatorio, .dados-paciente, .sinais-vitais')
              sections.forEach(section => section.style.pageBreakInside = 'avoid')
            }
          },
          jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
        }

        // Gera PDF como Blob
        const pdfBlob = await html2pdf().from(element).set(opt).output('blob')

        // Converte para Base64
        const base64 = await new Promise((resolve, reject) => {
          const reader = new FileReader()
          reader.onloadend = () => resolve(reader.result.split(',')[1])
          reader.onerror = reject
          reader.readAsDataURL(pdfBlob)
        })

        // Inverte Base64 (para segurança)
        const base64Invertido = base64.split('').reverse().join('')

        return {
          base64: base64Invertido, // invertido para armazenamento
          filename: `Triagem_${protocoloCompleto.value}.pdf`,
          size: pdfBlob.size,
          blob: pdfBlob
        }

      } catch (error) {
        console.error('❌ Erro ao gerar PDF:', error)
        throw new Error(`Erro ao gerar PDF: ${error.message}`)
      }
    }


    const salvarRelatorioCompleto = async (pdfData) => {
      try {
        const payload = {
          relatorio_triagem: {
            paciente_fake_id: triagem.paciente.id,
            enfermeiro_id: triagem.enfermeiro.id,
            medico_id: medicoSelecionado.value.id,
            classificacao_risco_id: triagem.classificacao.id,
            protocolo: protocoloCompleto.value,
            data_triagem: new Date().toISOString(),
            pdf_data: pdfData.base64,
            pdf_file_name: pdfData.filename,
            pdf_content_type: 'application/pdf',
            pdf_file_size: pdfData.size,
            sinais_vitais: { ...triagem.sinaisVitais },
            sintomas: {
              selecionados: triagem.sintomas.selecionados,
              outros_sintomas: triagem.sintomas.outrosSintomas,
              observacoes_clinicas: triagem.sintomas.observacoesClinicas
            },
            prioridades: triagem.prioridadesAtivas,
            comorbidades: triagem.comorbidadesAtivas,
            alergias: { ...triagem.alergias }
          }
        }

        const response = await axios.post('http://localhost:3001/api/relatorios_triagem', payload, {
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': `Bearer ${localStorage.getItem('authToken')}`
          }
        })

        if (response?.data?.id) {
          console.log(`✅ Relatório salvo com sucesso! ID: ${response.data.id}`)
          // Não abre o PDF automaticamente, apenas salva
        } else {
          throw new Error('Resposta inesperada do servidor.')
        }
      } catch (error) {
        console.error('❌ Erro ao salvar relatório:', error)
        const msg = error?.response?.data?.errors || 
                    error?.response?.data?.error || 
                    error.message
        throw new Error(`Erro ao salvar relatório: ${msg}`)
      }
    }

    const redirecionarParaNovaTriagem = () => {
      // Limpa os dados da triagem atual
      if (typeof triagem.limparDadosTriagem === 'function') {
        triagem.limparDadosTriagem()
      }
      
      // Limpa o paciente selecionado do localStorage
      localStorage.removeItem('paciente_selecionado')
      
      router.push('/menu/triagem-dados-paciente')
    }

    const dados = computed(() => triagem.generateReportData())

    return { 
      dados, 
      protocoloCompleto, 
      dataAtualFormatada, 
      formatarData, 
      formatarDataHora, 
      formatarHora,
      calcularIdade, 
      formatarSexo, 
      formatarCPF, 
      formatarTelefone, 
      corClassificacao, 
      calcularTotalGlasgow, 
      relatorioRef, 
      formatarSintoma, 
      formatarPrioridade, 
      formatarComorbidade,
      abrirModalMedicos,
      enviarParaMedico,
      enviando,
      showModalMedicos,
      showModalConfirmacao,
      medicosDisponiveis,
      medicoSelecionado,
      selecionarMedico,
      redirecionarParaNovaTriagem,
      tempoAtendimento,
      escalaDorTexto,
      escalaDorPorcentagem
    }
  }
}
</script>

<style scoped>
/* Estilos ABNT - Times New Roman, fonte 12, espaçamento 1.5 */
.relatorio-container {
  max-width: 210mm;
  margin: 0 auto;
  padding: 25mm;
  background-color: white;
  font-family: "Times New Roman", Times, serif;
  font-size: 12pt;
  line-height: 1.5;
  text-align: justify;
}

/* Estilos para o modal de médicos */
.modal-medicos {
  max-width: 600px;
}

.medicos-lista {
  max-height: 300px;
  overflow-y: auto;
  margin: 15px 0;
}

.medico-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 8px;
  margin-bottom: 10px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.medico-item:hover {
  background-color: #f5f5f5;
}

.medico-item.selecionado {
  border-color: #4CAF50;
  background-color: #e8f5e9;
}

.medico-info h4 {
  margin: 0 0 5px 0;
  color: #333;
}

.medico-info p {
  margin: 2px 0;
  font-size: 0.9em;
  color: #666;
}

.medico-selecao {
  color: #4CAF50;
  font-size: 1.2em;
}

.nenhum-medico {
  text-align: center;
  padding: 20px;
  color: #666;
}

.btn-confirmar {
  background-color: #4CAF50;
  color: white;
}

.btn-confirmar:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}

.modal-close {
  background: none;
  border: none;
  font-size: 1.2em;
  cursor: pointer;
  color: #666;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #eee;
  padding-bottom: 15px;
  margin-bottom: 15px;
}

/* Adicione estas regras CSS para evitar quebras de página */
.relatorio-container {
  max-width: 210mm;
  margin: 0 auto;
  padding: 25mm;
  background-color: white;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  font-family: "Times New Roman", Times, serif;
  font-size: 12pt;
  line-height: 1.5;
}

/* Evita quebras de página em elementos importantes */
.dados-principais,
.dados-paciente,
.sinais-vitais,
.secao-relatorio,
.cabecalho-institucional,
.rodape {
  page-break-inside: avoid;
  break-inside: avoid;
}

/* Garante que os grids não quebrem */
.dados-grid,
.sinais-grid,
.glasgow-grid {
  display: flex;
  justify-content: space-between;
  gap: 20px;
  page-break-inside: avoid;
  break-inside: avoid;
}

/* Mantém juntos os itens das listas */
.lista-itens {
  page-break-inside: avoid;
  break-inside: avoid;
}

.item-lista {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 5px;
  page-break-inside: avoid;
  break-inside: avoid;
}

/* Estilos mantidos do original com ajustes ABNT */
.cabecalho-institucional {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  border-bottom: 2px solid #333;
  padding-bottom: 15px;
}

.logo-container {
  flex: 0 0 100px;
}

.logo {
  max-width: 100%;
  height: auto;
}

.instituicao-info {
  flex: 1;
  text-align: center;
}

.instituicao-titulo {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
}

.instituicao-titulo h1 {
  margin: 0;
  font-size: 14pt;
  font-weight: bold;
}

.documento-tipo {
  font-weight: bold;
  margin: 5px 0 0;
  font-size: 12pt;
}

.documento-metadata {
  text-align: right;
  flex: 0 0 150px;
  font-size: 11pt;
}

.titulo-documento {
  text-align: center;
  margin: 20px 0;
  text-transform: uppercase;
  font-size: 14pt;
  font-weight: bold;
}

.dados-principais {
  display: flex;
  justify-content: space-between;
  padding: 15px;
  border-radius: 5px;
  margin-bottom: 20px;
  font-size: 11pt;
}

.classificacao-risco, .profissional-responsavel {
  flex: 1;
}

.dados-paciente, .sinais-vitais, .secao-relatorio {
  margin-bottom: 20px;
  padding: 15px;
  border: 1px solid #ddd;
  border-radius: 5px;
}

.dados-grid, .sinais-grid, .glasgow-grid {
  display: flex;
  justify-content: space-between;
  gap: 20px;
}

.dados-grid > div, .sinais-grid > div, .glasgow-grid > div {
  flex: 1;
}

.lista-itens {
  margin-top: 10px;
}

.item-lista {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 5px;
}

.campo-resposta {
  margin: 10px 0;
  padding: 10px;
  background-color: #f9f9f9;
  border-radius: 4px;
  border: 1px solid #ddd;
}

.rotulo-resposta {
  font-weight: bold;
  margin-right: 8px;
}

.escala-dor-visual {
  margin: 15px 0;
}

.escala-dor-bar {
  height: 20px;
  background-color: #eee;
  border-radius: 10px;
  overflow: hidden;
  margin-bottom: 5px;
}

.escala-dor-fill {
  height: 100%;
  background-color: #ff6b35;
  transition: width 0.3s ease;
}

.escala-dor-labels {
  display: flex;
  justify-content: space-between;
  font-size: 10pt;
}

.total-glasgow {
  font-size: 12pt;
  font-weight: bold;
}

.interpretacao-glasgow {
  margin-top: 5px;
  font-style: italic;
}

.nenhum-dado {
  font-style: italic;
  color: #888;
}

.data-medicao, .descricao-escala {
  text-align: right;
  color: #666;
  margin-top: 5px;
  font-size: 10pt;
}

.rodape {
  margin-top: 30px;
  padding-top: 15px;
  border-top: 1px solid #ddd;
  text-align: center;
  font-size: 11pt;
}

.instituicao-rodape {
  font-weight: bold;
  margin-bottom: 5px;
}

.info-rodape {
  display: flex;
  justify-content: space-between;
  margin-bottom: 5px;
}

.aviso-rodape {
  font-size: 10pt;
  color: #888;
}

.botoes-acao {
  display: flex;
  justify-content: center;
  gap: 15px;
  margin-top: 20px;
  padding: 20px;
}

.botao-enviar {
  background-color: #2196F3;
  color: white;
  border: none;
  padding: 12px 24px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12pt;
  font-family: "Times New Roman", Times, serif;
  transition: background-color 0.3s;
}

.botao-enviar:hover:not(:disabled) {
  background-color: #0b7dda;
}

.botao-enviar:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal {
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  max-width: 500px;
  width: 90%;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  font-family: "Times New Roman", Times, serif;
  font-size: 12pt;
}

.modal-header {
  border-bottom: 1px solid #eee;
  padding-bottom: 15px;
  margin-bottom: 15px;
}

.modal-header h3 {
  margin: 0;
  color: #4CAF50;
  font-size: 14pt;
}

.modal-body {
  margin-bottom: 20px;
}

.modal-footer {
  text-align: right;
}

.modal-footer button {
  background-color: #2196F3;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
  font-family: "Times New Roman", Times, serif;
  font-size: 11pt;
}

.modal-footer button:hover {
  background-color: #0b7dda;
}

/* Estilos para impressão em A4 */
@media print {
  .relatorio-container {
    box-shadow: none;
    padding: 0;
    max-width: 100%;
  }
  
  .botoes-acao {
    display: none;
  }
}
</style>
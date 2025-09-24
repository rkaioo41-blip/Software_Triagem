<template>
  <div class="container-relatorios">
    <div class="cabecalho-pagina">
      <h1><i class="fas fa-history"></i> Histórico de Triagens</h1>
      <p>Visualize e gerencie todas as triagens realizadas</p>
    </div>

    <div class="estatisticas-container">
      <div class="estatistica-card">
        <div class="estatistica-icon azul">
          <i class="fas fa-clipboard-list"></i>
        </div>
        <div class="estatistica-info">
          <h3>Total de Triagens</h3>
          <p class="estatistica-valor">{{ totalTriagens }}</p>
        </div>
      </div>
      
      <div class="estatistica-card">
        <div class="estatistica-icon vermelho">
          <i class="fas fa-exclamation-triangle"></i>
        </div>
        <div class="estatistica-info">
          <h3>Emergências</h3>
          <p class="estatistica-valor">{{ totalEmergencias }}</p>
          <p class="estatistica-porcentagem">{{ porcentagemEmergencias }}% do total</p>
        </div>
      </div>
      
      <div class="estatistica-card">
        <div class="estatistica-icon verde">
          <i class="fas fa-stethoscope"></i>
        </div>
        <div class="estatistica-info">
          <h3>Sintomas Frequentes</h3>
          <div class="lista-sintomas">
            <div v-for="(sintoma, index) in sintomasMaisFrequentes" :key="index" class="item-sintoma">
              <span class="nome-sintoma">{{ formatarSintoma(sintoma.nome) }}</span>
              <span class="quantidade-sintoma">{{ sintoma.quantidade }}</span>
            </div>
            <div v-if="sintomasMaisFrequentes.length === 0" class="sem-sintomas">
              Nenhum sintoma registrado
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="filtros-container">
      <div class="filtros-header">
        <h3><i class="fas fa-filter"></i> Filtros</h3>
      </div>
      <div class="filtros-body">
        <div class="filtro-group">
          <label>Data Inicial</label>
          <input type="date" v-model="filtroDataInicio" />
        </div>
        
        <div class="filtro-group">
          <label>Data Final</label>
          <input type="date" v-model="filtroDataFim" />
        </div>
        
        <div class="filtro-group">
          <label>Paciente</label>
          <input type="text" v-model="filtroPaciente" placeholder="Nome do paciente" />
        </div>
        
        <div class="filtro-group">
          <label>Classificação</label>
          <select v-model="filtroClassificacao">
            <option value="">Todas</option>
            <option value="vermelho">Vermelho</option>
            <option value="laranja">Laranja</option>
            <option value="amarelo">Amarelo</option>
            <option value="verde">Verde</option>
            <option value="azul">Azul</option>
          </select>
        </div>
        
        <div class="filtro-group">
          <label>Médico</label>
          <input type="text" v-model="filtroMedico" placeholder="Nome do médico" />
        </div>
        
        <div class="filtro-actions">
          <button @click="buscarTriagens" class="btn btn-primary">
            <i class="fas fa-search"></i> Buscar
          </button>
          <button @click="limparFiltros" class="btn btn-secondary">
            <i class="fas fa-eraser"></i> Limpar
          </button>
          <button @click="exportarCSV" class="btn btn-success">
            <i class="fas fa-file-csv"></i> Exportar CSV
          </button>
        </div>
      </div>
    </div>

    <div v-if="carregando" class="loading-container">
      <i class="fas fa-spinner fa-spin"></i>
      <p>Carregando triagens...</p>
    </div>

    <div v-else class="tabela-container">
      <div class="tabela-header">
        <h3>Triagens Realizadas</h3>
        <span class="resultados-info">{{ totalTriagens }} resultado(s) encontrado(s)</span>
      </div>
      
      <table class="tabela-relatorios">
        <thead>
          <tr>
            <th>Protocolo</th>
            <th>Data/Hora</th>
            <th>Paciente</th>
            <th>Classificação</th>
            <th>Enfermeiro</th>
            <th>Médico</th>
            <th class="text-center">Ações</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="triagensFiltradas.length === 0">
            <td colspan="7" class="sem-dados">
              <i class="fas fa-inbox"></i>
              <p>Nenhuma triagem encontrada</p>
            </td>
          </tr>
          <tr v-for="triagem in paginadas" :key="triagem.id">
            <td class="protocolo">TRI{{ triagem.protocolo }}</td>
            <td>{{ formatarDataHora(triagem.data_triagem) }}</td>
            <td class="paciente-nome">{{ triagem.paciente_fake?.nome || 'N/A' }}</td>
            <td>
              <div class="classificacao-container">
                <span class="classificacao-bolinha" :class="triagem.classificacao_risco?.nivel || 'azul'"></span>
                {{ triagem.classificacao_risco?.nome_nivel || 'N/A' }}
              </div>
            </td>
            <td>{{ triagem.enfermeiro?.nome || 'N/A' }}</td>
            <td>{{ triagem.medico?.nome || 'N/A' }}</td>
            <td>
              <div class="acoes-container">
                <button @click="visualizarRelatorio(triagem)" class="btn-acao btn-info" title="Detalhes">
                  <i class="fas fa-eye"></i>
                </button>
                <button @click="gerenciarPDF(triagem, 'visualizar')" class="btn-acao btn-pdf" 
                        :disabled="!triagem.pdf_disponivel" title="Visualizar PDF">
                  <i class="fas fa-file-pdf"></i>
                </button>
                <button @click="gerenciarPDF(triagem, 'baixar')" class="btn-acao btn-download" 
                        :disabled="!triagem.pdf_disponivel" title="Baixar PDF">
                  <i class="fas fa-download"></i>
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="paginacao-container" v-if="totalPaginas > 1">
      <div class="paginacao-info">
        Mostrando {{ inicioItem }}-{{ fimItem }} de {{ totalTriagens }} itens
      </div>
      <div class="paginacao-controles">
        <button @click="paginaAnterior" :disabled="paginaAtual === 1" class="btn-paginacao">
          <i class="fas fa-chevron-left"></i>
        </button>
        <span class="pagina-atual">Página {{ paginaAtual }} de {{ totalPaginas }}</span>
        <button @click="paginaProxima" :disabled="paginaAtual === totalPaginas" class="btn-paginacao">
          <i class="fas fa-chevron-right"></i>
        </button>
      </div>
    </div>

    <div v-if="relatorioSelecionado" class="modal-overlay" @click="fecharModal">
      <div class="modal-conteudo" @click.stop>
        <div class="modal-cabecalho">
          <h2>Detalhes da Triagem - TRI{{ relatorioSelecionado.protocolo }}</h2>
          <button @click="fecharModal" class="btn-fechar">
            <i class="fas fa-times"></i>
          </button>
        </div>
        <div class="modal-corpo">
          <div class="detalhes-grid">
            <div class="detalhe-item">
              <label>Paciente:</label>
              <span>{{ relatorioSelecionado.paciente_fake?.nome || 'N/A' }}</span>
            </div>
            <div class="detalhe-item">
              <label>Data/Hora:</label>
              <span>{{ formatarDataHora(relatorioSelecionado.data_triagem) }}</span>
            </div>
            <div class="detalhe-item">
              <label>Classificação:</label>
              <span>
                <span class="classificacao-bolinha" :class="relatorioSelecionado.classificacao_risco?.nivel"></span>
                {{ relatorioSelecionado.classificacao_risco?.nome_nivel || 'N/A' }}
              </span>
            </div>
            <div class="detalhe-item">
              <label>Enfermeiro:</label>
              <span>{{ relatorioSelecionado.enfermeiro?.nome || 'N/A' }} (COREN: {{ relatorioSelecionado.enfermeiro?.coren || 'N/A' }})</span>
            </div>
            <div class="detalhe-item">
              <label>Médico:</label>
              <span>{{ relatorioSelecionado.medico?.nome || 'N/A' }} (CRM: {{ relatorioSelecionado.medico?.crm || 'N/A' }})</span>
            </div>
          </div>
        </div>
        <div class="modal-rodape">
          <button @click="gerenciarPDF(relatorioSelecionado, 'visualizar')" class="btn btn-pdf" 
                  :disabled="!relatorioSelecionado.pdf_disponivel">
            <i class="fas fa-file-pdf"></i> Visualizar PDF
          </button>
          <button @click="gerenciarPDF(relatorioSelecionado, 'baixar')" class="btn btn-download" 
                  :disabled="!relatorioSelecionado.pdf_disponivel">
            <i class="fas fa-download"></i> Baixar PDF
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import { MAPA_SINTOMAS } from '@/constantes/sintomas'

export default {
  name: 'DadosRelatorios',
  data() {
    return {
      filtroDataInicio: '',
      filtroDataFim: '',
      filtroPaciente: '',
      filtroClassificacao: '',
      filtroMedico: '',
      paginaAtual: 1,
      itensPorPagina: 10,
      triagens: [],
      carregando: false,
      relatorioSelecionado: null,
      sintomasEstatisticas: {},
      usuarioLogado: null
    }
  },
  computed: {
    triagensFiltradas() {
      return this.triagens.filter(triagem => {
        const dataTriagem = new Date(triagem.data_triagem)
        const filtroInicio = this.filtroDataInicio ? new Date(this.filtroDataInicio) : null
        const filtroFim = this.filtroDataFim ? new Date(this.filtroDataFim) : null

        const dentroPeriodo =
          (!filtroInicio || dataTriagem >= filtroInicio) &&
          (!filtroFim || dataTriagem <= new Date(filtroFim.setHours(23, 59, 59)))

        const pacienteMatch = this.filtroPaciente.trim() === '' ||
          (triagem.paciente_fake?.nome?.toLowerCase().includes(this.filtroPaciente.trim().toLowerCase()))

        const classificacaoMatch = this.filtroClassificacao === '' ||
          triagem.classificacao_risco?.nivel === this.filtroClassificacao

        const medicoMatch = this.filtroMedico.trim() === '' ||
          (triagem.medico?.nome?.toLowerCase().includes(this.filtroMedico.trim().toLowerCase()))

        return dentroPeriodo && pacienteMatch && classificacaoMatch && medicoMatch
      })
    },
    totalTriagens() { return this.triagensFiltradas.length },
    totalEmergencias() { return this.triagensFiltradas.filter(t => t.classificacao_risco?.nivel === 'vermelho').length },
    porcentagemEmergencias() { return this.totalTriagens === 0 ? 0 : ((this.totalEmergencias / this.totalTriagens) * 100).toFixed(1) },
    sintomasMaisFrequentes() {
      return Object.entries(this.sintomasEstatisticas)
        .map(([nome, quantidade]) => ({ nome, quantidade }))
        .sort((a, b) => b.quantidade - a.quantidade)
        .slice(0, 3)
    },
    totalPaginas() { return Math.ceil(this.triagensFiltradas.length / this.itensPorPagina) },
    inicioItem() { return (this.paginaAtual - 1) * this.itensPorPagina + 1 },
    fimItem() {
      const fim = this.paginaAtual * this.itensPorPagina
      return fim > this.totalTriagens ? this.totalTriagens : fim
    },
    paginadas() {
      const inicio = (this.paginaAtual - 1) * this.itensPorPagina
      const fim = inicio + this.itensPorPagina
      return this.triagensFiltradas.slice(inicio, fim)
    }
  },
  methods: {
    formatarDataHora(data) { return new Date(data).toLocaleString('pt-BR') },
    formatarSintoma(valor) { return MAPA_SINTOMAS[valor] || this.formatarTexto(valor) },
    formatarTexto(texto) { return texto?.split('_').map(p => p.charAt(0).toUpperCase() + p.slice(1)).join(' ') || '' },

    async carregarTriagens() {
      this.carregando = true
      try {
        const response = await axios.get('http://localhost:3001/api/relatorios_triagem', {
          params: { enfermeiro_id: this.usuarioLogado.id },
          headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
        })
        this.triagens = response.data
      } catch (error) {
        console.error('Erro ao carregar triagens:', error)
        alert('Erro ao carregar triagens do servidor.')
      } finally {
        this.carregando = false
      }
    },
    async carregarEstatisticas() {
      try {
        const response = await axios.get('http://localhost:3001/api/relatorios_triagem/estatisticas', {
          params: { enfermeiro_id: this.usuarioLogado.id }, 
          headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
        })
        this.sintomasEstatisticas = response.data.sintomas || {}
      } catch (error) {
        console.error('Erro ao carregar estatísticas:', error)
      }
    },
    buscarTriagens() { this.paginaAtual = 1 },
    limparFiltros() {
      this.filtroDataInicio = ''
      this.filtroDataFim = ''
      this.filtroPaciente = ''
      this.filtroClassificacao = ''
      this.filtroMedico = ''
      this.paginaAtual = 1
    },

    visualizarRelatorio(triagem) { this.relatorioSelecionado = triagem },
    fecharModal() { this.relatorioSelecionado = null },

    async gerenciarPDF(triagem, acao) {
      if (!triagem.pdf_disponivel) return
      try {
        const response = await axios.get(
          `http://localhost:3001/api/relatorios_triagem/${triagem.id}/download`,
          {
            responseType: 'text',
            headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
          }
        )
        
        const base64Revertido = response.data.split('').reverse().join('')
        const binario = atob(base64Revertido)
        const array = new Uint8Array(binario.length)
        for (let i = 0; i < binario.length; i++) {
          array[i] = binario.charCodeAt(i)
        }
        const finalBlob = new Blob([array], { type: 'application/pdf' })

        const url = window.URL.createObjectURL(finalBlob)
        if (acao === 'visualizar') {
          window.open(url, '_blank')
        } else {
          const link = document.createElement('a')
          link.href = url
          link.download = `Triagem_${triagem.protocolo}.pdf`
          document.body.appendChild(link)
          link.click()
          document.body.removeChild(link)
        }
        
        setTimeout(() => window.URL.revokeObjectURL(url), 10000)

      } catch (error) {
        console.error('Erro ao processar PDF:', error)
        alert('Erro ao processar o PDF. Verifique o console.')
      }
    },

    exportarCSV() {
      let csv = 'Protocolo,Data,Paciente,Classificação,Enfermeiro,Médico\n'
      this.triagensFiltradas.forEach(t => {
        csv += `TRI${t.protocolo},${t.data_triagem},${t.paciente_fake?.nome || 'N/A'},${t.classificacao_risco?.nome_nivel || 'N/A'},${t.enfermeiro?.nome || 'N/A'},${t.medico?.nome || 'N/A'}\n`
      })
      const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' })
      const link = document.createElement('a')
      link.href = URL.createObjectURL(blob)
      link.setAttribute('download', `triagens_${new Date().toISOString().split('T')[0]}.csv`)
      document.body.appendChild(link)
      link.click()
      document.body.removeChild(link)
    },

    paginaAnterior() { if (this.paginaAtual > 1) this.paginaAtual-- },
    paginaProxima() { if (this.paginaAtual < this.totalPaginas) this.paginaAtual++ }
  },
  mounted() {
    this.usuarioLogado = JSON.parse(localStorage.getItem('usuario'))
    this.carregarTriagens()
    this.carregarEstatisticas()
  }
}
</script>

<style scoped>
.container-relatorios {
  padding: 20px;
  background-color: #f8f9fa;
  min-height: 100vh;
}

.cabecalho-pagina {
  margin-bottom: 30px;
  text-align: center;
}

.cabecalho-pagina h1 {
  color: #2c3e50;
  margin-bottom: 5px;
  font-size: 28px;
}

.cabecalho-pagina p {
  color: #7f8c8d;
  font-size: 16px;
}

.estatisticas-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.estatistica-card {
  background: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  display: flex;
  align-items: center;
  transition: transform 0.2s;
}

.estatistica-card:hover {
  transform: translateY(-5px);
}

.estatistica-icon {
  width: 60px;
  height: 60px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 15px;
  font-size: 24px;
  color: white;
}

.estatistica-icon.azul { background: #3498db; }
.estatistica-icon.vermelho { background: #e74c3c; }
.estatistica-icon.verde { background: #2ecc71; }

.estatistica-info h3 {
  margin: 0 0 5px 0;
  font-size: 14px;
  color: #7f8c8d;
  font-weight: 600;
}

.estatistica-valor {
  margin: 0;
  font-size: 28px;
  font-weight: bold;
  color: #2c3e50;
}

.estatistica-porcentagem {
  margin: 5px 0 0 0;
  font-size: 12px;
  color: #7f8c8d;
}

.lista-sintomas {
  margin-top: 10px;
}

.item-sintoma {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
  padding: 5px 0;
  border-bottom: 1px solid #f1f2f6;
}

.item-sintoma:last-child {
  border-bottom: none;
}

.nome-sintoma {
  font-size: 13px;
  color: #2c3e50;
}

.quantidade-sintoma {
  background: #3498db;
  color: white;
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: bold;
}

.sem-sintomas {
  font-size: 13px;
  color: #95a5a6;
  text-align: center;
  padding: 10px 0;
}

.filtros-container {
  background: white;
  border-radius: 12px;
  margin-bottom: 30px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  overflow: hidden;
}

.filtros-header {
  background: #3498db;
  color: white;
  padding: 15px 20px;
}

.filtros-header h3 {
  margin: 0;
  font-size: 18px;
}

.filtros-body {
  padding: 20px;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 15px;
}

.filtro-group {
  display: flex;
  flex-direction: column;
}

.filtro-group label {
  margin-bottom: 5px;
  font-weight: 600;
  color: #2c3e50;
  font-size: 14px;
}

.filtro-group input,
.filtro-group select {
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 14px;
}

.filtro-actions {
  grid-column: 1 / -1;
  display: flex;
  gap: 10px;
  justify-content: flex-end;
  margin-top: 10px;
}

.btn {
  padding: 10px 15px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 5px;
  transition: all 0.2s;
}

.btn-primary {
  background: #3498db;
  color: white;
}

.btn-primary:hover {
  background: #2980b9;
}

.btn-secondary {
  background: #95a5a6;
  color: white;
}

.btn-secondary:hover {
  background: #7f8c8d;
}

.btn-success {
  background: #2ecc71;
  color: white;
}

.btn-success:hover {
  background: #27ae60;
}

.loading-container {
  text-align: center;
  padding: 40px;
  color: #7f8c8d;
}

.loading-container i {
  font-size: 32px;
  margin-bottom: 15px;
  color: #3498db;
}

.tabela-container {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  margin-bottom: 20px;
}

.tabela-header {
  padding: 20px;
  border-bottom: 1px solid #f1f2f6;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.tabela-header h3 {
  margin: 0;
  color: #2c3e50;
}

.resultados-info {
  color: #7f8c8d;
  font-size: 14px;
}

.tabela-relatorios {
  width: 100%;
  border-collapse: collapse;
}

.tabela-relatorios th {
  background: #f8f9fa;
  padding: 15px;
  text-align: left;
  font-weight: 600;
  color: #2c3e50;
  border-bottom: 2px solid #e9ecef;
}

.tabela-relatorios td {
  padding: 15px;
  border-bottom: 1px solid #f1f2f6;
  color: #2c3e50;
}

.tabela-relatorios tr:hover {
  background: #f8f9fa;
}

.protocolo {
  font-weight: 600;
  color: #3498db;
}

.paciente-nome {
  font-weight: 500;
}

.classificacao-container {
  display: flex;
  align-items: center;
  gap: 8px;
}

.classificacao-bolinha {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  display: inline-block;
}

.classificacao-bolinha.vermelho { background: #e74c3c; }
.classificacao-bolinha.laranja { background: #f39c12; }
.classificacao-bolinha.amarelo { background: #f1c40f; }
.classificacao-bolinha.verde { background: #2ecc71; }
.classificacao-bolinha.azul { background: #3498db; }

.acoes-container {
  display: flex;
  gap: 8px;
  justify-content: center;
}

.btn-acao {
  width: 36px;
  height: 36px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
}

.btn-info {
  background: #3498db;
  color: white;
}

.btn-info:hover {
  background: #2980b9;
}

.btn-pdf {
  background: #e74c3c;
  color: white;
}

.btn-pdf:hover {
  background: #c0392b;
}

.btn-download {
  background: #2ecc71;
  color: white;
}

.btn-download:hover {
  background: #27ae60;
}

.btn-acao:disabled {
  background: #bdc3c7;
  cursor: not-allowed;
}

.sem-dados {
  text-align: center;
  padding: 40px;
  color: #95a5a6;
}

.sem-dados i {
  font-size: 48px;
  margin-bottom: 15px;
  display: block;
}

.text-center {
  text-align: center;
}

.paginacao-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: white;
  padding: 15px 20px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.paginacao-info {
  color: #7f8c8d;
  font-size: 14px;
}

.paginacao-controles {
  display: flex;
  align-items: center;
  gap: 15px;
}

.btn-paginacao {
  width: 36px;
  height: 36px;
  border: 1px solid #ddd;
  background: white;
  border-radius: 6px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
}

.btn-paginacao:hover:not(:disabled) {
  background: #3498db;
  color: white;
  border-color: #3498db;
}

.btn-paginacao:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.pagina-atual {
  font-weight: 600;
  color: #2c3e50;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 20px;
}

.modal-conteudo {
  background: white;
  border-radius: 12px;
  width: 100%;
  max-width: 600px;
  max-height: 90vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
}

.modal-cabecalho {
  padding: 20px;
  border-bottom: 1px solid #f1f2f6;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #3498db;
  color: white;
}

.modal-cabecalho h2 {
  margin: 0;
  font-size: 20px;
}

.btn-fechar {
  background: none;
  border: none;
  color: white;
  font-size: 20px;
  cursor: pointer;
  padding: 5px;
}

.modal-corpo {
  padding: 20px;
  overflow-y: auto;
}

.detalhes-grid {
  display: grid;
  gap: 15px;
}

.detalhe-item {
  display: grid;
  grid-template-columns: 120px 1fr;
  gap: 10px;
  align-items: center;
}

.detalhe-item label {
  font-weight: 600;
  color: #2c3e50;
}

.detalhe-item span {
  color: #2c3e50;
}

.modal-rodape {
  padding: 20px;
  border-top: 1px solid #f1f2f6;
  display: flex;
  gap: 10px;
  justify-content: flex-end;
}

.btn-pdf, .btn-download {
  padding: 10px 15px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 5px;
  transition: all 0.2s;
}

.btn-pdf {
  background: #e74c3c;
  color: white;
}

.btn-pdf:hover:not(:disabled) {
  background: #c0392b;
}

.btn-download {
  background: #2ecc71;
  color: white;
}

.btn-download:hover:not(:disabled) {
  background: #27ae60;
}

.btn-pdf:disabled, .btn-download:disabled {
  background: #bdc3c7;
  cursor: not-allowed;
}

@media (max-width: 768px) {
  .estatisticas-container {
    grid-template-columns: 1fr;
  }
  
  .filtros-body {
    grid-template-columns: 1fr;
  }
  
  .filtro-actions {
    flex-direction: column;
  }
  
  .tabela-header {
    flex-direction: column;
    gap: 10px;
    align-items: flex-start;
  }
  
  .paginacao-container {
    flex-direction: column;
    gap: 15px;
  }
  
  .detalhe-item {
    grid-template-columns: 1fr;
    gap: 5px;
  }
  
  .modal-cabecalho h2 {
    font-size: 18px;
  }
}
</style>
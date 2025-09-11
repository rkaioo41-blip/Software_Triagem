<template>
  <div class="form-container">
    <!-- Cabeçalho -->
    <div class="form-header">
      <h1><i class="fas fa-user-injured"></i> Dados do Paciente</h1>
      <p>Preencha as informações pessoais do paciente para iniciar a triagem</p>
    </div>

    <!-- Busca por Código SUS - MODIFICADO -->
    <div class="card">
      <div class="card-header">
        <i class="fas fa-search"></i>
        <h3>Buscar por Código SUS</h3>
      </div>
      <div class="card-body">
        <div class="form-group">
          <label><i class="fas fa-id-card"></i> Código SUS</label>
          <div class="sus-search-container">
            <input
              type="text"
              v-model="codigoSUS"
              placeholder="Digite o código SUS do paciente"
              @keyup.enter="buscarPorCodigoSUS"
              class="sus-input"
            />
            <button @click="buscarPorCodigoSUS" class="btn btn-primary sus-search-btn" :disabled="!codigoSUS">
              <i class="fas fa-search"></i> Buscar
            </button>
          </div>
          <p class="search-help-text">
            <i class="fas fa-info-circle"></i> Digite o código de 15 dígitos do Cartão Nacional de Saúde
          </p>
        </div>
      </div>
    </div>

    <!-- Restante do formulário (mantido igual) -->
    <div class="card">
      <div class="card-body form-grid">
        <!-- Nome e CPF -->
        <div class="form-group">
          <label><i class="fas fa-user"></i> Nome completo <span class="required">*</span></label>
          <input type="text" v-model="paciente.nome" placeholder="Nome completo do paciente" required />
        </div>
        <div class="form-group">
          <label><i class="fas fa-id-card"></i> CPF <span class="required">*</span></label>
          <input type="text" v-model="paciente.cpf" v-mask="'###.###.###-##'" placeholder="000.000.000-00" required />
        </div>

        <!-- Sexo e Data de nascimento -->
        <div class="form-group">
          <label><i class="fas fa-venus-mars"></i> Sexo <span class="required">*</span></label>
          <select v-model="paciente.sexo" required @change="handleSexoChange">
            <option value="" disabled>Selecione</option>
            <option>Masculino</option>
            <option>Feminino</option>
            <option>Outro</option>
            <option>Prefiro não informar</option>
          </select>
          <input v-if="mostrarCampoSexoOutro" type="text" v-model="paciente.sexoOutro" placeholder="Especifique o sexo" @input="atualizarSexo" />
        </div>
        <div class="form-group">
          <label><i class="fas fa-calendar-alt"></i> Data de nascimento <span class="required">*</span></label>
          <input type="date" v-model="paciente.data_nascimento" required />
        </div>

        <!-- Endereço e Cidade -->
        <div class="form-group">
          <label><i class="fas fa-map-marker-alt"></i> Endereço <span class="required">*</span></label>
          <input type="text" v-model="paciente.endereco" placeholder="Endereço completo" required />
        </div>
        <div class="form-group">
          <label><i class="fas fa-city"></i> Cidade <span class="required">*</span></label>
          <input type="text" v-model="paciente.cidade" placeholder="Cidade" required />
        </div>

        <!-- Nome do pai e da mãe -->
        <div class="form-group">
          <label><i class="fas fa-male"></i> Nome do pai</label>
          <input type="text" v-model="paciente.nomePai" placeholder="Nome completo do pai" />
        </div>
        <div class="form-group">
          <label><i class="fas fa-female"></i> Nome da mãe</label>
          <input type="text" v-model="paciente.nomeMae" placeholder="Nome completo da mãe" />
        </div>

        <!-- Raça e Orientação -->
        <div class="form-group">
          <label><i class="fas fa-palette"></i> Raça/Cor</label>
          <select v-model="paciente.racaCor">
            <option value="" disabled>Selecione</option>
            <option>Branca</option>
            <option>Parda</option>
            <option>Preta</option>
            <option>Amarela</option>
            <option>Indígena</option>
            <option>Prefiro não informar</option>
          </select>
        </div>
        <div class="form-group">
          <label><i class="fas fa-heart"></i> Informar orientação sexual?</label>
          <select v-model="paciente.informaOrientacao">
            <option value="" disabled>Selecione</option>
            <option>Sim</option>
            <option>Não</option>
          </select>
        </div>
        <div class="form-group full-width" v-if="paciente.informaOrientacao === 'Sim'">
          <label><i class="fas fa-heartbeat"></i> Orientação sexual</label>
          <input type="text" v-model="paciente.orientacaoSexual" placeholder="Orientação sexual" />
        </div>

        <!-- Identidade e Nome social -->
        <div class="form-group">
          <label><i class="fas fa-transgender-alt"></i> Identidade de gênero</label>
          <input type="text" v-model="paciente.identidadeGenero" placeholder="Identidade de gênero" />
        </div>
        <div class="form-group">
          <label><i class="fas fa-signature"></i> Nome social</label>
          <input type="text" v-model="paciente.nomeSocial" placeholder="Nome social" />
        </div>
      </div>
    </div>

    <!-- Resultado da Busca -->
    <div v-if="resultadoBusca" class="card success">
      <div class="card-header">
        <i class="fas fa-info-circle"></i>
        <h3>Resultado da Busca</h3>
      </div>
      <div class="card-body">
        <p>{{ resultadoBusca }}</p>
      </div>
    </div>

    <!-- Botões -->
    <div class="actions">
      <button @click="limparPaciente" class="btn btn-secondary" :disabled="!temDados">
        <i class="fas fa-eraser"></i> Limpar
      </button>
      <button @click="enviarPaciente" class="btn btn-primary" :disabled="!formularioValido">
        <i class="fas fa-check"></i> Confirmar e Continuar
      </button>
    </div>
  </div>
</template>

<script>
import { useTriagem } from '@/stores/triagem'
import { mask } from 'vue-the-mask'

export default {
  directives: { mask },
  data() {
    return {
      codigoSUS: '',
      mostrarCampoSexoOutro: false,
      paciente: {
        nome: '', cpf: '', sexo: '', sexoOutro: '', data_nascimento: '',
        endereco: '', cidade: '', nomePai: '', nomeMae: '',
        racaCor: '', informaOrientacao: '', orientacaoSexual: '',
        identidadeGenero: '', nomeSocial: ''
      },
      resultadoBusca: null
    }
  },
  computed: {
    temDados() {
      return Object.values(this.paciente).some(v => v)
    },
    formularioValido() {
      return this.paciente.nome && this.paciente.cpf && this.paciente.sexo &&
             this.paciente.data_nascimento && this.paciente.endereco && this.paciente.cidade
    }
  },
  methods: {
    handleSexoChange() {
      this.mostrarCampoSexoOutro = this.paciente.sexo === 'Outro'
      if (!this.mostrarCampoSexoOutro) this.paciente.sexoOutro = ''
    },
    atualizarSexo() {
      if (this.mostrarCampoSexoOutro) this.paciente.sexo = this.paciente.sexoOutro
    },
    async buscarPorCodigoSUS() {
      if (!this.codigoSUS.trim()) return
      try {
        const response = await fetch(`http://localhost:3001/api/pacientes_fake/${this.codigoSUS.trim()}`)
        if (!response.ok) {
          this.resultadoBusca = 'Código SUS não encontrado.'
          this.limparPaciente()
          return
        }
        const p = await response.json()
        this.paciente = {
          id: p.id, nome: p.nome, cpf: p.cpf, sexo: p.sexo, sexoOutro: '',
          data_nascimento: p.data_nascimento, endereco: p.endereco, cidade: p.cidade,
          nomePai: p.nome_pai, nomeMae: p.nome_mae, racaCor: p.raca_cor,
          informaOrientacao: p.informa_orientacao, orientacaoSexual: p.orientacao_sexual,
          identidadeGenero: p.identidade_genero, nomeSocial: p.nome_social
        }
        this.resultadoBusca = 'Paciente localizado com sucesso!'
      } catch {
        this.resultadoBusca = 'Erro ao buscar paciente.'
      }
    },
    limparBusca() {
      this.codigoSUS = ''
    },
    async enviarPaciente() {
      if (!this.formularioValido) return
      const triagemStore = useTriagem()
      await triagemStore.setPaciente(this.paciente)
      this.$router.push('/menu/sinais-vitais')
    },
    limparPaciente() {
      Object.keys(this.paciente).forEach(k => this.paciente[k] = '')
      this.codigoSUS = ''
      this.resultadoBusca = null
      this.mostrarCampoSexoOutro = false
    }
  }
}
</script>

<style scoped>
/* Container */
.form-container { max-width: 900px; margin: 0 auto; padding: 20px; }

/* Cabeçalho */
.form-header { text-align: center; margin-bottom: 25px; }
.form-header h1 { font-size: 24px; color: #2c3e50; }
.form-header p { color: #7f8c8d; }

/* Card padrão */
.card {
  background: #fff;
  border-radius: 10px;
  margin-bottom: 20px;
  border: 1px solid #e0e0e0;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}
.card-header {
  display: flex; align-items: center; gap: 8px;
  background: #f8f9fa;
  padding: 12px 20px;
  font-weight: 600; color: #3498db;
  border-bottom: 1px solid #e0e0e0;
  border-radius: 10px 10px 0 0;
}
.card-body { padding: 20px; }
.card.success { border-left: 4px solid #2ecc71; }

/* Grid do formulário */
.form-grid { display: grid; grid-template-columns: repeat(auto-fit,minmax(280px,1fr)); gap: 15px; }
.form-group { display: flex; flex-direction: column; }
.form-group.full-width { grid-column: 1 / -1; }
.form-group label { font-weight: 600; margin-bottom: 5px; font-size: 14px; color: #2c3e50; }
.required { color: #e74c3c; }

/* Inputs */
input, select {
  padding: 10px 12px;
  border: 1px solid #ccc; border-radius: 6px;
  font-size: 14px; transition: all .2s;
}
input:focus, select:focus {
  border-color: #3498db;
  box-shadow: 0 0 0 2px rgba(52,152,219,0.1);
  outline: none;
}

/* Botões */
.btn { padding: 10px 18px; border: none; border-radius: 6px; font-weight: 600; cursor: pointer; transition: .2s; display: inline-flex; align-items: center; gap: 6px; font-size: 14px; }
.btn:disabled { opacity: 0.6; cursor: not-allowed; }
.btn-primary { background: #3498db; color: #fff; }
.btn-primary:hover:not(:disabled) { background: #2980b9; }
.btn-secondary { background: #2ecc71; color: #fff; }
.btn-secondary:hover:not(:disabled) { background: #27ae60; }

/* Ações */
.actions { display: flex; gap: 12px; justify-content: flex-end; margin-top: 20px; border-top: 1px solid #ecf0f1; padding-top: 15px; }

/* Novos estilos para a busca SUS */
.sus-search-container {
  display: flex;
  gap: 12px;
  align-items: stretch;
}

.sus-input {
  flex: 1;
  padding: 10px 12px;
  border: 1px solid #ccc;
  border-radius: 6px;
  font-size: 14px;
  transition: all .2s;
}

.sus-input:focus {
  border-color: #3498db;
  box-shadow: 0 0 0 2px rgba(52,152,219,0.1);
  outline: none;
}

.sus-search-btn {
  white-space: nowrap;
}

.search-help-text {
  margin-top: 8px;
  font-size: 13px;
  color: #7f8c8d;
  display: flex;
  align-items: center;
  gap: 6px;
}

/* Responsividade */
@media (max-width: 600px) {
  .actions { flex-direction: column; }
  .btn { width: 100%; justify-content: center; }
  
  .sus-search-container {
    flex-direction: column;
  }
}
</style>
<template>
  <div class="form-container">
    <!-- Cabeçalho -->
    <div class="form-header">
      <h1><i class="fas fa-heartbeat"></i> Sinais Vitais</h1>
      <p>Registro dos dados clínicos recentes do paciente</p>
    </div>

    <!-- Card de Sinais Vitais -->
    <div class="card">
      <div class="card-body form-grid">
        <!-- Temperatura e Frequência Cardíaca -->
        <div class="form-group">
          <label><i class="fas fa-thermometer-half"></i> Temperatura (°C)</label>
          <input
            type="number"
            v-model="sinais.temperatura"
            :min="intervalosSinais.temperatura.min"
            :max="intervalosSinais.temperatura.max"
            step="0.1"
            placeholder="36.5"
          />
          <span class="help-text">
            Normal: {{intervalosSinais.temperatura.min}}°C - {{intervalosSinais.temperatura.max}}°C
          </span>
        </div>

        <div class="form-group">
          <label><i class="fas fa-heartbeat"></i> Frequência Cardíaca (bpm)</label>
          <input
            type="number"
            v-model="sinais.frequenciaCardiaca"
            :min="intervalosSinais.frequenciaCardiaca.min"
            :max="intervalosSinais.frequenciaCardiaca.max"
            placeholder="72"
          />
          <span class="help-text">
            Normal: {{intervalosSinais.frequenciaCardiaca.min}} - {{intervalosSinais.frequenciaCardiaca.max}} bpm
          </span>
        </div>

        <!-- Saturação e Pressão -->
        <div class="form-group">
          <label><i class="fas fa-lungs"></i> Saturação de O₂ (%)</label>
          <input
            type="number"
            v-model="sinais.saturacao"
            :min="intervalosSinais.saturacao.min"
            :max="intervalosSinais.saturacao.max"
            placeholder="98"
          />
          <span class="help-text">Normal: ≥ {{intervalosSinais.saturacao.min}}%</span>
        </div>

        <div class="form-group">
          <label><i class="fas fa-tachometer-alt"></i> Pressão Arterial (mmHg)</label>
          <input
            type="text"
            v-model="sinais.pressaoArterial"
            v-mask="'###/###'"
            placeholder="120/80"
          />
          <span class="help-text">Formato: sistólica/diastólica</span>
        </div>

        <!-- Frequência Resp. e Glicemia -->
        <div class="form-group">
          <label><i class="fas fa-wind"></i> Frequência Respiratória (irpm)</label>
          <input
            type="number"
            v-model="sinais.frequenciaRespiratoria"
            :min="intervalosSinais.frequenciaRespiratoria.min"
            :max="intervalosSinais.frequenciaRespiratoria.max"
            placeholder="16"
          />
          <span class="help-text">
            Normal: {{intervalosSinais.frequenciaRespiratoria.min}} - {{intervalosSinais.frequenciaRespiratoria.max}} irpm
          </span>
        </div>

        <div class="form-group">
          <label><i class="fas fa-vial"></i> Glicemia (mg/dL)</label>
          <input
            type="number"
            v-model="sinais.glicemia"
            :min="intervalosSinais.glicemia.min"
            :max="intervalosSinais.glicemia.max"
            placeholder="90"
          />
          <span class="help-text">Normal em jejum: 70-99 mg/dL</span>
        </div>

        <!-- Escala de Dor -->
        <div class="form-group full-width">
          <label><i class="fas fa-procedures"></i> Escala de Dor (0 a 10)</label>
          <input type="number" v-model="sinais.escalaDor" min="0" max="10" placeholder="0 = sem dor, 10 = pior dor" />
          <span class="help-text">{{ descricaoDor }}</span>
        </div>

        <!-- Glasgow -->
        <div class="form-group">
          <label><i class="fas fa-eye"></i> Abertura Ocular</label>
          <select v-model="sinais.glasgowOcular">
            <option disabled value="">Selecione</option>
            <option v-for="(desc, valor) in opcoesGlasgow.ocular" :key="valor" :value="valor">
              {{ valor }} - {{ desc }}
            </option>
          </select>
        </div>
        <div class="form-group">
          <label><i class="fas fa-comment"></i> Resposta Verbal</label>
          <select v-model="sinais.glasgowVerbal">
            <option disabled value="">Selecione</option>
            <option v-for="(desc, valor) in opcoesGlasgow.verbal" :key="valor" :value="valor">
              {{ valor }} - {{ desc }}
            </option>
          </select>
        </div>
        <div class="form-group">
          <label><i class="fas fa-running"></i> Resposta Motora</label>
          <select v-model="sinais.glasgowMotora">
            <option disabled value="">Selecione</option>
            <option v-for="(desc, valor) in opcoesGlasgow.motora" :key="valor" :value="valor">
              {{ valor }} - {{ desc }}
            </option>
          </select>
        </div>

        <!-- Total -->
        <div class="form-group">
          <label><i class="fas fa-calculator"></i> Glasgow Total</label>
          <input type="number" :value="glasgowTotal" disabled />
        </div>
      </div>
    </div>

    <!-- Botões -->
    <div class="actions">
      <button @click="voltar" class="btn btn-secondary">
        <i class="fas fa-arrow-left"></i> Voltar
      </button>
      <button @click="limparSinais" class="btn btn-secondary" :disabled="!temDados">
        <i class="fas fa-eraser"></i> Limpar
      </button>
      <button @click="enviarSinais" class="btn btn-primary" :disabled="!formularioValido">
        <i class="fas fa-check"></i> Confirmar
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
      sinais: {
        temperatura: '43', frequenciaCardiaca: '43', saturacao: '43',
        pressaoArterial: '43', frequenciaRespiratoria: '43',
        glicemia: '', escalaDor: '10', glasgowOcular: '1',
        glasgowVerbal: '1', glasgowMotora: '1'
      },
      intervalosSinais: {
        temperatura: { min: 30, max: 45 },
        frequenciaCardiaca: { min: 30, max: 200 },
        saturacao: { min: 70, max: 100 },
        frequenciaRespiratoria: { min: 8, max: 40 },
        glicemia: { min: 40, max: 500 }
      },
      opcoesGlasgow: {
        ocular: { 4: 'Espontânea', 3: 'Ao comando verbal', 2: 'À dor', 1: 'Nenhuma' },
        verbal: { 5: 'Orientado', 4: 'Confuso', 3: 'Palavras inapropriadas', 2: 'Incompreensível', 1: 'Nenhuma' },
        motora: { 6: 'Obedece comandos', 5: 'Localiza dor', 4: 'Flexão normal', 3: 'Flexão anormal', 2: 'Extensão', 1: 'Nenhuma' }
      }
    }
  },
  computed: {
    glasgowTotal() {
      return (Number(this.sinais.glasgowOcular) || 0) + (Number(this.sinais.glasgowVerbal) || 0) + (Number(this.sinais.glasgowMotora) || 0)
    },
    descricaoDor() {
      const v = Number(this.sinais.escalaDor)
      if (!v && v !== 0) return "Informe a intensidade da dor"
      if (v <= 3) return "Dor leve"
      if (v <= 6) return "Dor moderada"
      if (v <= 10) return "Dor intensa"
      return "Valor inválido"
    },
    temDados() { return Object.values(this.sinais).some(v => v) },
    formularioValido() {
      return this.sinais.temperatura && this.sinais.frequenciaCardiaca &&
             this.sinais.pressaoArterial && this.sinais.frequenciaRespiratoria
    }
  },
  methods: {
    async enviarSinais() {
      if (!this.formularioValido) return
      const triagemStore = useTriagem()
      await triagemStore.setSinaisVitais(this.sinais)
      this.$router.push('/menu/selecao-sintomas')
    },
    limparSinais() { Object.keys(this.sinais).forEach(k => this.sinais[k] = '') },
    voltar() { this.$router.push('/menu/triagem-dados-paciente') }
  }
}
</script>

<style scoped>
/* Reuso dos estilos de DadosPaciente.vue */

/* Container */
.form-container { max-width: 900px; margin: 0 auto; padding: 20px; }

/* Cabeçalho */
.form-header { text-align: center; margin-bottom: 25px; }
.form-header h1 { font-size: 24px; color: #2c3e50; }
.form-header p { color: #7f8c8d; }

/* Card */
.card {
  background: #fff;
  border-radius: 10px;
  margin-bottom: 20px;
  border: 1px solid #e0e0e0;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}
.card-body { padding: 20px; }

/* Grid */
.form-grid { display: grid; grid-template-columns: repeat(auto-fit,minmax(280px,1fr)); gap: 15px; }
.form-group { display: flex; flex-direction: column; }
.form-group.full-width { grid-column: 1 / -1; }
.form-group label { font-weight: 600; margin-bottom: 5px; font-size: 14px; color: #2c3e50; }
.help-text { font-size: 12px; color: #7f8c8d; margin-top: 5px; font-style: italic; }

/* Inputs */
input, select {
  padding: 10px 12px;
  border: 1px solid #ccc; border-radius: 6px;
  font-size: 14px; transition: all .2s;
  background: #f8fafc;
}
input:focus, select:focus {
  border-color: #3498db;
  box-shadow: 0 0 0 2px rgba(52,152,219,0.1);
  outline: none;
  background: white;
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

/* Responsivo */
@media (max-width: 600px) {
  .actions { flex-direction: column; }
  .btn { width: 100%; justify-content: center; }
}
</style>

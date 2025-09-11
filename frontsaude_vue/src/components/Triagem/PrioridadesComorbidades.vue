<template>
  <div class="formulario-container">
    <header class="cabecalho-formulario">
      <h1 class="titulo-formulario">Prioridades e Comorbidades</h1>
      <p class="subtitulo-formulario">Informe as condições especiais do paciente</p>
    </header>

    <!-- Campo de Busca -->
    <div class="container-busca">
      <div class="wrapper-busca">
        <i class="fas fa-search icone-busca"></i>
        <input
          type="text"
          v-model="termoBusca"
          placeholder="Buscar condições..."
          class="input-busca"
          @keyup.esc="limparBusca"
        />
        <button v-if="termoBusca" @click="limparBusca" class="botao-limpar-busca">
          <i class="fas fa-times"></i>
        </button>
      </div>
    </div>

    <!-- Contador de Selecionados -->
    <div class="contador-selecionados" v-if="totalSelecionados > 0">
      <span class="texto-contador">
        <i class="fas fa-check-circle"></i> {{ totalSelecionados }} condição(ões) selecionada(s)
      </span>
      <button @click="limparSelecao" class="botao-limpar-tudo">
        <i class="fas fa-trash-alt"></i> Limpar seleção
      </button>
    </div>

    <!-- Prioridades Clínicas -->
    <div class="grupo-categoria">
      <h3 class="titulo-categoria">
        <i class="fas fa-exclamation-triangle icone-categoria"></i> Prioridades Clínicas
      </h3>
      <div class="grupo-condicoes">
        <div v-for="(item, chave) in prioridadesFiltradas" :key="chave" class="item-condicao">
          <label class="checkbox-condicao">
            <input
              type="checkbox"
              v-model="formulario.condicoes"
              :value="chave"
              class="checkbox-oculto"
            />
            <span class="checkbox-customizado" :class="{selecionado: formulario.condicoes.includes(chave)}">
              <i class="fas fa-check" v-if="formulario.condicoes.includes(chave)"></i>
            </span>
            <span class="texto-condicao" v-html="destacarCorrespondencia(item.texto)"></span>
          </label>
        </div>
      </div>
    </div>

    <!-- Comorbidades de Risco -->
    <div class="grupo-categoria">
      <h3 class="titulo-categoria">
        <i class="fas fa-heartbeat icone-categoria"></i> Comorbidades de Risco
      </h3>
      <div class="grupo-condicoes">
        <div v-for="(item, chave) in comorbidadesFiltradas" :key="chave" class="item-condicao">
          <label class="checkbox-condicao">
            <input
              type="checkbox"
              v-model="formulario.condicoes"
              :value="chave"
              class="checkbox-oculto"
            />
            <span class="checkbox-customizado" :class="{selecionado: formulario.condicoes.includes(chave)}">
              <i class="fas fa-check" v-if="formulario.condicoes.includes(chave)"></i>
            </span>
            <span class="texto-condicao" v-html="destacarCorrespondencia(item.texto)"></span>
          </label>
        </div>
      </div>
    </div>

    <!-- Alergias a Medicamentos -->
    <div class="grupo-categoria">
      <h3 class="titulo-categoria">
        <i class="fas fa-allergies icone-categoria"></i> Alergia a Medicamentos
      </h3>
      <div class="grupo-alergias">
        <div class="grupo-radio">
          <label class="opcao-radio">
            <input type="radio" v-model="formulario.alergiaMedicacao" value="nao">
            <span class="marcador-radio"></span>
            <span class="texto-opcao">Não</span>
          </label>
          
          <label class="opcao-radio">
            <input type="radio" v-model="formulario.alergiaMedicacao" value="sim">
            <span class="marcador-radio"></span>
            <span class="texto-opcao">Sim</span>
          </label>
        </div>

        <div class="grupo-textarea" v-if="formulario.alergiaMedicacao === 'sim'">
          <label class="rotulo-textarea">
            <i class="fas fa-pills icone-textarea"></i>
            Quais medicamentos?
            <span class="texto-obrigatorio">*</span>
          </label>
          <textarea
            v-model="formulario.qualAlergia"
            class="textarea-customizado"
            rows="3"
            placeholder="Informe os medicamentos aos quais o paciente é alérgico..."
            :class="{ 'invalido': mostrarErroAlergia }"
          ></textarea>
          <div v-if="mostrarErroAlergia" class="mensagem-erro">
            <i class="fas fa-exclamation-circle"></i> Este campo é obrigatório quando há alergia
          </div>
        </div>
      </div>
    </div>

    <!-- Mensagem quando nenhum resultado é encontrado -->
    <div v-if="mostrarNenhumResultado" class="nenhum-resultado">
      <i class="fas fa-search-minus"></i>
      Nenhuma condição encontrada com o termo "{{ termoBusca }}"
    </div>

    <!-- Botões de Ação -->
    <div class="acoes-formulario">
      <button @click="voltar" class="botao-acao botao-voltar">
        <i class="fas fa-arrow-left"></i> Voltar
      </button>
      <button @click="limparFormulario" class="botao-acao botao-limpar" :disabled="!temDados">
        <i class="fas fa-eraser"></i> Limpar
      </button>
      <button @click="enviarFormulario" class="botao-acao botao-enviar" :disabled="!formularioValido">
        <i class="fas fa-check"></i> Confirmar
      </button>
    </div>
  </div>
</template>

<script>
import { useTriagem } from '@/stores/triagem';

export default {
  name: 'PrioridadesComorbidades',
  data() {
    return {
      termoBusca: '',
      mostrarErroAlergia: false,
      formulario: {
        condicoes: [],
        alergiaMedicacao: 'nao',
        qualAlergia: ''
      },
      condicoesPadrao: {
        // Prioridades Clínicas
        idoso: { texto: "👵 Idoso (≥ 60 anos)", categoria: "prioridade" },
        gestante: { texto: "🤰 Gestante", categoria: "prioridade" },
        crianca: { texto: "👶 Lactente/criança pequena (< 2 anos)", categoria: "prioridade" },
        pcd: { texto: "♿ Pessoa com deficiência física ou mental", categoria: "prioridade" },
        acamado: { texto: "🛏️ Paciente acamado", categoria: "prioridade" },
        autista: { texto: "🧠 Transtorno mental ou espectro autista", categoria: "prioridade" },
        
        // Comorbidades de Risco
        cardiopatia: { texto: "🫀 Cardiopatia", categoria: "comorbidade" },
        avc: { texto: "🧠 AVC prévio", categoria: "comorbidade" },
        diabetes: { texto: "💉 Diabetes Mellitus", categoria: "comorbidade" },
        has: { texto: "💊 Hipertensão Arterial Sistêmica (HAS)", categoria: "comorbidade" },
        dpoc: { texto: "🫁 DPOC/Asma", categoria: "comorbidade" },
        cancer: { texto: "🧬 Câncer ativo", categoria: "comorbidade" },
        imunossuprimido: { texto: "🧫 Imunossuprimido (HIV, quimioterapia, imunobiológicos)", categoria: "comorbidade" },
        obesidade: { texto: "⚖️ Obesidade Grau II ou III", categoria: "comorbidade" },
        drc: { texto: "🧯 Doença Renal Crônica", categoria: "comorbidade" }
      }
    }
  },
  computed: {
    temDados() {
      return this.formulario.condicoes.length > 0 || 
             this.formulario.alergiaMedicacao === 'sim';
    },
    formularioValido() {
      const alergiaValida = this.formulario.alergiaMedicacao !== 'sim' || 
                          (this.formulario.alergiaMedicacao === 'sim' && this.formulario.qualAlergia.trim() !== '');
      return this.temDados && alergiaValida;
    },
    prioridadesFiltradas() {
      return this.filtrarCondicoes('prioridade');
    },
    comorbidadesFiltradas() {
      return this.filtrarCondicoes('comorbidade');
    },
    mostrarNenhumResultado() {
      return this.termoBusca && 
             Object.keys(this.prioridadesFiltradas).length === 0 && 
             Object.keys(this.comorbidadesFiltradas).length === 0;
    },
    totalSelecionados() {
      return this.formulario.condicoes.length;
    }
  },
  watch: {
    'formulario.alergiaMedicacao'(novoValor) {
      if (novoValor === 'sim') {
        this.mostrarErroAlergia = false;
      }
    },
    'formulario.qualAlergia'(novoValor) {
      if (novoValor.trim() !== '') {
        this.mostrarErroAlergia = false;
      }
    }
  },
  methods: {
    filtrarCondicoes(tipo) {
      const filtradas = {};
      const termo = this.termoBusca.toLowerCase().trim();
      
      for (const [chave, item] of Object.entries(this.condicoesPadrao)) {
        if (item.categoria === tipo) {
          if (!termo || 
              item.texto.toLowerCase().includes(termo) || 
              chave.toLowerCase().includes(termo)) {
            filtradas[chave] = item;
          }
        }
      }
      
      return filtradas;
    },
    limparBusca() {
      this.termoBusca = '';
    },
    limparSelecao() {
      this.formulario.condicoes = [];
    },
    async enviarFormulario() {
      if (this.formulario.alergiaMedicacao === 'sim' && this.formulario.qualAlergia.trim() === '') {
        this.mostrarErroAlergia = true
        return
      }

      const triagemStore = useTriagem()

      const prioridades = this.formulario.condicoes.filter(chave => this.condicoesPadrao[chave].categoria === 'prioridade')
      const comorbidades = this.formulario.condicoes.filter(chave => this.condicoesPadrao[chave].categoria === 'comorbidade')

      triagemStore.setPrioridadesSelecionadas(prioridades)
      triagemStore.setComorbidadesSelecionadas(comorbidades)
      triagemStore.definirAlergias({
        possuiAlergia: this.formulario.alergiaMedicacao === 'sim',
        descricao: this.formulario.qualAlergia
      })

      this.$router.push('/menu/classificacao')
    },
    limparFormulario() {
      this.formulario.condicoes = [];
      this.formulario.alergiaMedicacao = 'nao';
      this.formulario.qualAlergia = '';
      this.mostrarErroAlergia = false;
    },
    voltar() {
      this.$router.push('/menu/selecao-sintomas');
    },
    destacarCorrespondencia(texto) {
      if (!this.termoBusca.trim()) return texto;
      
      const termo = this.termoBusca.trim();
      const regex = new RegExp(termo, 'gi');
      
      return texto.replace(regex, match => `<span class="destaque">${match}</span>`);
    }
  }
}
</script>

<style scoped>
/* Container principal */
.formulario-container {
  max-width: 900px;
  margin: 0 auto;
  padding: 20px;
}

/* Cabeçalho */
.cabecalho-formulario {
  text-align: center;
  margin-bottom: 25px;
}
.cabecalho-formulario h1 {
  font-size: 24px;
  color: #2c3e50;
}
.cabecalho-formulario p {
  color: #7f8c8d;
}

/* Campo de busca */
.container-busca {
  margin-bottom: 20px;
}
.wrapper-busca {
  position: relative;
  display: flex;
  align-items: center;
}
.input-busca {
  width: 100%;
  padding: 10px 12px 10px 36px;
  border: 1px solid #ccc;
  border-radius: 6px;
  font-size: 14px;
  transition: all .2s;
  background: #f8fafc;
}
.input-busca:focus {
  border-color: #3498db;
  box-shadow: 0 0 0 2px rgba(52,152,219,0.1);
  outline: none;
  background: #fff;
}
.icone-busca {
  position: absolute;
  left: 10px;
  top: 50%;
  transform: translateY(-50%); /* Centraliza verticalmente */
  color: #7f8c8d;
  font-size: 14px; /* garante proporção */
}

.botao-limpar-busca {
  position: absolute;
  right: 10px;
  border: none;
  background: none;
  cursor: pointer;
  color: #7f8c8d;
}

/* Contador */
.contador-selecionados {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px;
  font-size: 14px;
  background: #f8fafc;
  border-radius: 6px;
  border: 1px solid #e0e0e0;
  margin-bottom: 20px;
}
.texto-contador i {
  color: #2ecc71;
  margin-right: 6px;
}
.botao-limpar-tudo {
  border: none;
  background: none;
  color: #e74c3c;
  cursor: pointer;
  font-size: 14px;
}

/* Categorias */
.grupo-categoria {
  background: #fff;
  border-radius: 10px;
  margin-bottom: 20px;
  border: 1px solid #e0e0e0;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
  padding: 20px;
}
.titulo-categoria {
  font-size: 16px;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 10px;
  border-bottom: 1px solid #ecf0f1;
  padding-bottom: 5px;
  display: flex;
  align-items: center;
  gap: 6px;
}
.grupo-condicoes {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 12px;
}

.checkbox-condicao {
  display: flex;
  align-items: flex-start; /* Alinha checkbox no topo */
  padding: 10px;
  cursor: pointer;
  gap: 8px;
}

.checkbox-customizado {
  flex-shrink: 0; /* mantém tamanho fixo */
  margin-top: 2px; /* alinha com a primeira linha do texto */
}

.texto-condicao {
  font-size: 14px;
  color: #2c3e50;
  line-height: 1.4;
  word-break: break-word; /* evita estouro de container */
}

.checkbox-oculto { display: none; }
.checkbox-customizado {
  width: 18px;
  height: 18px;
  border: 2px solid #ccc;
  border-radius: 4px;
  margin-right: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.checkbox-customizado.selecionado {
  background: #3498db;
  border-color: #3498db;
  color: #fff;
}
.texto-condicao {
  font-size: 14px;
  color: #2c3e50;
}

/* Alergias */
.grupo-alergias {
  background: #fff;
  border-radius: 10px;
  margin-bottom: 20px;
  border: 1px solid #e0e0e0;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
  padding: 20px;
}
.grupo-radio {
  display: flex;
  gap: 1.5rem;
  margin-bottom: 1.5rem;
}
.opcao-radio {
  display: flex;
  align-items: center;
  position: relative;
  padding-left: 28px;
  cursor: pointer;
}
.opcao-radio input { position: absolute; opacity: 0; }
.marcador-radio {
  position: absolute;
  left: 0;
  height: 20px;
  width: 20px;
  border: 1px solid #ccc;
  border-radius: 50%;
  background: #f8fafc;
}
.opcao-radio input:checked ~ .marcador-radio {
  background: #3498db;
  border-color: #3498db;
}
.marcador-radio:after {
  content: "";
  position: absolute;
  top: 6px;
  left: 6px;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #fff;
  display: none;
}
.opcao-radio input:checked ~ .marcador-radio:after {
  display: block;
}
.texto-opcao {
  font-size: 14px;
  margin-left: 8px;
}

/* Textarea */
.grupo-textarea { margin-top: 1rem; }
.rotulo-textarea {
  display: flex;
  align-items: center;
  font-size: 14px;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 6px;
}
.texto-obrigatorio { color: #e74c3c; margin-left: 0.25rem; }
.textarea-customizado {
  width: 100%;
  padding: 10px 12px;
  border: 1px solid #ccc;
  border-radius: 6px;
  font-size: 14px;
  background: #f8fafc;
  resize: vertical;
}
.textarea-customizado:focus {
  border-color: #3498db;
  box-shadow: 0 0 0 2px rgba(52,152,219,0.1);
  outline: none;
  background: white;
}
.textarea-customizado.invalido {
  border-color: #e74c3c;
  background: #fff5f5;
}
.mensagem-erro {
  color: #e74c3c;
  font-size: 13px;
  margin-top: 5px;
  display: flex;
  align-items: center;
  gap: 6px;
}

/* Nenhum resultado */
.nenhum-resultado {
  text-align: center;
  padding: 20px;
  color: #7f8c8d;
  border: 1px dashed #ccc;
  border-radius: 6px;
  margin-bottom: 20px;
}

/* Botões */
.acoes-formulario {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 20px;
  border-top: 1px solid #ecf0f1;
  padding-top: 15px;
}
.botao-acao {
  padding: 10px 18px;
  border: none;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  transition: .2s;
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
}
.botao-acao:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
.botao-enviar {
  background: #3498db;
  color: #fff;
}
.botao-enviar:hover:not(:disabled) {
  background: #2980b9;
}
.botao-limpar {
  background: #2ecc71;
  color: #fff;
}
.botao-limpar:hover:not(:disabled) {
  background: #27ae60;
}
.botao-voltar {
  background: #e67e22;
  color: #fff;
}
.botao-voltar:hover {
  background: #d35400;
}

/* Destaque busca */
.destaque {
  background: #fff3cd;
  padding: 0 2px;
  border-radius: 3px;
  font-weight: 500;
}

/* Responsivo */
@media (max-width: 600px) {
  .acoes-formulario {
    flex-direction: column;
  }
  .botao-acao {
    width: 100%;
    justify-content: center;
  }
}
</style>

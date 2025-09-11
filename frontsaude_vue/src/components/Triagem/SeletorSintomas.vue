<template>
  <div class="formulario-container">
    <header class="cabecalho-formulario">
      <h1 class="titulo-formulario">Registro de Sintomas</h1>
      <p class="subtitulo-formulario">Selecione os sintomas apresentados pelo paciente</p>
    </header>

    <!-- Campo de Busca -->
    <div class="container-busca">
      <div class="wrapper-busca">
        <i class="fas fa-search icone-busca"></i>
        <input
          type="text"
          v-model="termoBusca"
          placeholder="Buscar sintomas..."
          class="input-busca"
          @keyup.esc="limparBusca"
        />
        <button v-if="termoBusca" @click="limparBusca" class="botao-limpar-busca">
          <i class="fas fa-times"></i>
        </button>
      </div>
    </div>

    <!-- Contador de Sintomas Selecionados -->
    <div class="contador-selecionados" v-if="sintomasSelecionados.length > 0">
      <span class="texto-contador">
        <i class="fas fa-check-circle"></i> {{ sintomasSelecionados.length }} sintoma(s) selecionado(s)
      </span>
      <button @click="limparSelecao" class="botao-limpar-tudo">
        <i class="fas fa-trash-alt"></i> Limpar seleção
      </button>
    </div>

    <!-- Grade de Sintomas -->
    <div v-if="Object.keys(sintomasAgrupados).length > 0" class="grade-sintomas">
      <div v-for="(sintomas, categoria) in sintomasAgrupados" :key="categoria" class="grupo-categoria">
        <h3 class="titulo-categoria">
          <span v-if="categoria === 'Geral'">🌡️ {{ categoria }}</span>
          <span v-else-if="categoria === 'Neurológico'">🧠 {{ categoria }}</span>
          <span v-else-if="categoria === 'Respiratório'">🫁 {{ categoria }}</span>
          <span v-else-if="categoria === 'Gastrointestinal'">🧻 {{ categoria }}</span>
          <span v-else-if="categoria === 'Muscular'">💪 {{ categoria }}</span>
          <span v-else-if="categoria === 'Sensorial'">👁️👂 {{ categoria }}</span>
          <span v-else-if="categoria === 'Dermatológico'">🧴 {{ categoria }}</span>
          <span v-else-if="categoria === 'Cardiovascular'">❤️ {{ categoria }}</span>
          <span v-else-if="categoria === 'Geniturinário'">🚽 {{ categoria }}</span>
          <span v-else-if="categoria === 'Ginecológico'">🌸 {{ categoria }}</span>
          <span v-else-if="categoria === 'Trauma'">🩹 {{ categoria }}</span>
          <span v-else-if="categoria === 'Endocrinológico'">🦋 {{ categoria }}</span>
          <span v-else-if="categoria === 'Pediátrico'">🧸 {{ categoria }}</span>
          <span v-else>{{ categoria }}</span>
        </h3>
        <div class="grupo-sintomas">
          <div v-for="sintoma in sintomas" :key="sintoma.valor" class="item-sintoma">
            <label class="checkbox-sintoma">
              <input
                type="checkbox"
                v-model="sintomasSelecionados"
                :value="sintoma.valor"
                class="checkbox-oculto"
              />
              <span class="checkbox-customizado" :class="{selecionado: sintomasSelecionados.includes(sintoma.valor)}">
                <i class="fas fa-check" v-if="sintomasSelecionados.includes(sintoma.valor)"></i>
              </span>
              <span class="texto-sintoma" v-html="destacarCorrespondencia(sintoma.texto)"></span>
            </label>
          </div>
        </div>
      </div>
    </div>

    <!-- Mensagem quando nenhum sintoma é encontrado na busca -->
    <div v-if="termoBusca && sintomasFiltrados.length === 0" class="nenhum-resultado">
      <i class="fas fa-search-minus"></i>
      Nenhum sintoma encontrado com o termo "{{ termoBusca }}"
    </div>

    <!-- Campos Adicionais -->
    <div class="secao-campos-adicionais">
      <div class="grupo-campo">
        <label class="rotulo-campo">
          <i class="fas fa-plus-circle"></i> Outros sintomas não listados
        </label>
        <textarea
          v-model="outrosSintomas"
          class="textarea-customizado"
          placeholder="Descreva quaisquer outros sintomas relevantes..."
          rows="3"
        ></textarea>
      </div>

      <div class="grupo-campo">
        <label class="rotulo-campo">
          <i class="fas fa-clipboard-list"></i> Observações clínicas
        </label>
        <textarea
          v-model="observacoesClinicas"
          class="textarea-customizado"
          placeholder="Histórico relevante, medicamentos, alergias, etc..."
          rows="3"
        ></textarea>
      </div>
    </div>

    <!-- Botões de Ação -->
    <div class="acoes-formulario">
      <button @click="voltar" class="botao-acao botao-voltar">
        <i class="fas fa-arrow-left"></i> Voltar
      </button>
        <button @click="limparFormulario" class="botao-acao botao-limpar" :disabled="!temDados">
        <i class="fas fa-eraser"></i> Limpar
      </button>
      <button @click="enviar" class="botao-acao botao-enviar" :disabled="!temSintomas">
        <i class="fas fa-check"></i> Continuar
      </button>
    </div>
  </div>
</template>

<script>
import { useTriagem } from '@/stores/triagem'

export default {
  data() {
    return {
      sintomasSelecionados: [],
      termoBusca: '',
      outrosSintomas: 'Sintomas de dor',
      observacoesClinicas: 'Sem Observações',
      listaSintomas: [
        // Sintomas Gerais
        { texto: "Febre", valor: "febre", categoria: "Geral" },
        { texto: "Calafrios", valor: "calafrios", categoria: "Geral" },
        { texto: "Fadiga", valor: "fadiga", categoria: "Geral" },
        { texto: "Mal-estar geral", valor: "mal_estar", categoria: "Geral" },

        // Neurológico
        { texto: "Dor de cabeça", valor: "dor_cabeca", categoria: "Neurológico" },
        { texto: "Tontura", valor: "tontura", categoria: "Neurológico" },
        { texto: "Convulsão", valor: "convulsao", categoria: "Neurológico" },
        { texto: "Déficit motor súbito", valor: "deficit_motor", categoria: "Neurológico" },
        { texto: "Confusão mental", valor: "confusao_mental", categoria: "Neurológico" },
        { texto: "Alteração do nível de consciência", valor: "alteracao_consciencia", categoria: "Neurológico" },

        // Respiratório
        { texto: "Tosse", valor: "tosse", categoria: "Respiratório" },
        { texto: "Falta de ar", valor: "falta_ar", categoria: "Respiratório" },
        { texto: "Dor de garganta", valor: "dor_garganta", categoria: "Respiratório" },
        { texto: "Chiado no peito", valor: "chiado_peito", categoria: "Respiratório" },
        { texto: "Produção de escarro", valor: "escarro", categoria: "Respiratório" },
        { texto: "Apneia", valor: "apneia", categoria: "Respiratório" },

        // Gastrointestinal
        { texto: "Náusea", valor: "nausea", categoria: "Gastrointestinal" },
        { texto: "Vômitos", valor: "vomitos", categoria: "Gastrointestinal" },
        { texto: "Diarreia", valor: "diarreia", categoria: "Gastrointestinal" },
        { texto: "Dor abdominal", valor: "dor_abdominal", categoria: "Gastrointestinal" },
        { texto: "Sangue nas fezes", valor: "sangue_fezes", categoria: "Gastrointestinal" },
        { texto: "Constipação", valor: "constipacao", categoria: "Gastrointestinal" },
        { texto: "Distensão abdominal", valor: "distensao_abdominal", categoria: "Gastrointestinal" },

        // Muscular
        { texto: "Dor muscular", valor: "dor_muscular", categoria: "Muscular" },
        { texto: "Dor nas articulações", valor: "dor_articulacoes", categoria: "Muscular" },

        // Sensorial
        { texto: "Perda de olfato", valor: "perda_olfato", categoria: "Sensorial" },
        { texto: "Perda de paladar", valor: "perda_paladar", categoria: "Sensorial" },

        // Dermatológico
        { texto: "Erupção cutânea", valor: "erupcao_cutanea", categoria: "Dermatológico" },
        { texto: "Coceira", valor: "coceira", categoria: "Dermatológico" },

        // Cardiovascular
        { texto: "Dor torácica", valor: "dor_toracica", categoria: "Cardiovascular" },
        { texto: "Palpitações", valor: "palpitacoes", categoria: "Cardiovascular" },
        { texto: "Edema de membros inferiores", valor: "edema_mmii", categoria: "Cardiovascular" },
        { texto: "Pressão alta", valor: "pressao_alta", categoria: "Cardiovascular" },

        // Geniturinário
        { texto: "Dor ao urinar", valor: "disuria", categoria: "Geniturinário" },
        { texto: "Urina com sangue", valor: "hematúria", categoria: "Geniturinário" },
        { texto: "Retenção urinária", valor: "retencao_urinaria", categoria: "Geniturinário" },

        // Ginecológico
        { texto: "Sangramento vaginal", valor: "sangramento_vaginal", categoria: "Ginecológico" },
        { texto: "Dor pélvica", valor: "dor_pelvica", categoria: "Ginecológico" },
        { texto: "Atraso menstrual", valor: "atraso_menstrual", categoria: "Ginecológico" },

        // Trauma
        { texto: "Fratura exposta", valor: "fratura_exposta", categoria: "Trauma" },
        { texto: "Entorse", valor: "entorse", categoria: "Trauma" },
        { texto: "Ferimento com sangramento", valor: "ferimento_sangramento", categoria: "Trauma" },

        // Endocrinológico
        { texto: "Hipoglicemia", valor: "hipoglicemia", categoria: "Endocrinológico" },
        { texto: "Hiperglicemia", valor: "hiperglicemia", categoria: "Endocrinológico" },
        { texto: "Sudorese excessiva", valor: "sudorese", categoria: "Endocrinológico" },

        // Pediátrico
        { texto: "Choro inconsolável", valor: "choro_inconsolavel", categoria: "Pediátrico" },
        { texto: "Letargia", valor: "letargia", categoria: "Pediátrico" },
        { texto: "Irritabilidade", valor: "irritabilidade", categoria: "Pediátrico" },
      ]
    }
  },
  computed: {
    sintomasFiltrados() {
      if (!this.termoBusca.trim()) return this.listaSintomas
      
      const termo = this.termoBusca.toLowerCase().trim()
      return this.listaSintomas.filter(sintoma => 
        sintoma.texto.toLowerCase().includes(termo) || 
        sintoma.valor.toLowerCase().includes(termo)
      )
    },
    sintomasAgrupados() {
      const agrupados = {}

      this.sintomasFiltrados.forEach(sintoma => {
        if (!agrupados[sintoma.categoria]) {
          agrupados[sintoma.categoria] = []
        }
        agrupados[sintoma.categoria].push(sintoma)
      })

      return agrupados
    },
    temSintomas() {
      return this.sintomasSelecionados.length > 0 || this.outrosSintomas.trim().length > 0
    },
    temDados() {
      return (
        this.sintomasSelecionados.length > 0 ||
        this.outrosSintomas.trim().length > 0 ||
        this.observacoesClinicas.trim().length > 0 ||
        this.termoBusca.trim().length > 0
      )
    }
  },
  methods: {
    limparBusca() {
      this.termoBusca = ''
    },
    limparSelecao() {
      this.sintomasSelecionados = []
    },
    destacarCorrespondencia(texto) {
      if (!this.termoBusca.trim()) return texto
      const termo = this.termoBusca.trim()
      const regex = new RegExp(termo, 'gi')
      return texto.replace(regex, match => `<span class="destaque">${match}</span>`)
    },
    async enviar() {
      const triagemStore = useTriagem()
      await triagemStore.setSintomasCompletos({
        selecionados: this.sintomasSelecionados,
        outrosSintomas: this.outrosSintomas,
        observacoesClinicas: this.observacoesClinicas
      })
      this.$router.push('/menu/prioridades-comorbidades')
    },
    voltar() {
      this.$router.push('/menu/sinais-vitais')
    },
    limparFormulario() {
      this.sintomasSelecionados = []
      this.outrosSintomas = ''
      this.observacoesClinicas = ''
      this.termoBusca = ''
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

/* Card / Box */
.grade-sintomas,
.secao-campos-adicionais {
  background: #fff;
  border-radius: 10px;
  margin-bottom: 20px;
  border: 1px solid #e0e0e0;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
  padding: 20px;
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
  color: #7f8c8d;
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

/* Categoria */
.titulo-categoria {
  font-size: 16px;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 10px;
  border-bottom: 1px solid #ecf0f1;
  padding-bottom: 5px;
}
.grupo-sintomas {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px,1fr));
  gap: 12px;
}
.item-sintoma {
  border: 1px solid #e0e0e0;
  border-radius: 6px;
  background: #fff;
  transition: all .2s;
}
.item-sintoma:hover {
  border-color: #3498db;
  box-shadow: 0 2px 6px rgba(52,152,219,0.15);
}
.checkbox-sintoma {
  display: flex;
  align-items: center;
  padding: 10px;
  cursor: pointer;
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
.texto-sintoma {
  font-size: 14px;
  color: #2c3e50;
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

/* Campos adicionais */
.grupo-campo {
  margin-bottom: 15px;
}
.rotulo-campo {
  font-weight: 600;
  margin-bottom: 6px;
  font-size: 14px;
  color: #2c3e50;
  display: flex;
  align-items: center;
  gap: 6px;
}
.textarea-customizado {
  width: 100%;
  padding: 10px 12px;
  border: 1px solid #ccc;
  border-radius: 6px;
  font-size: 14px;
  transition: all .2s;
  background: #f8fafc;
  resize: vertical;
}
.textarea-customizado:focus {
  border-color: #3498db;
  box-shadow: 0 0 0 2px rgba(52,152,219,0.1);
  outline: none;
  background: white;
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

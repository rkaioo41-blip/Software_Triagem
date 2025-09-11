<template>
  <div class="classificacao-container">
    <header class="cabecalho-classificacao">
      <h1 class="titulo-classificacao">
        <i class="fas fa-triage"></i> Classificação de Risco
      </h1>
      <p class="subtitulo-classificacao">Selecione o nível de urgência conforme protocolo Manchester</p>
    </header>

    <div v-if="carregando" class="carregando-container">
      <i class="fas fa-spinner fa-spin"></i> Carregando classificações...
    </div>

    <div v-else-if="erro" class="erro-container">
      <i class="fas fa-exclamation-triangle"></i> Erro ao carregar classificações: {{ erro }}
      <button @click="carregarClassificacoes" class="botao-tentar-novamente">
        <i class="fas fa-redo"></i> Tentar Novamente
      </button>
    </div>

    <div v-else class="opcoes-classificacao">
      <div 
        v-for="classificacao in classificacoes" 
        :key="classificacao.id"
        class="card-classificacao" 
        :class="[classificacao.nivel, { selecionado: nivelSelecionado === classificacao.id }]"
        @click="selecionarNivel(classificacao.id)"
      >
        <div class="indicador-cor"></div>
        <div class="conteudo-classificacao">
          <div class="cabecalho-card">
            <h3 class="nivel-classificacao">{{ classificacao.nome_nivel }}</h3>
            <div class="tempo-atendimento">
              <i class="fas fa-stopwatch"></i> {{ classificacao.tempo_atendimento }}
            </div>
          </div>
          <p class="descricao-classificacao">{{ classificacao.descricao }}</p>
          <div class="exemplos-container">
            <h4 class="titulo-exemplos">
              <i class="fas fa-list-ul"></i> Exemplos:
            </h4>
            <ul class="exemplos-classificacao">
              <li v-for="(exemplo, index) in classificacao.exemplos" :key="index">
                <span class="icone-exemplo">{{ exemplo.icone }}</span> {{ exemplo.texto }}
              </li>
            </ul>
          </div>
        </div>
        <div class="seletor-radio">
          <input 
            type="radio" 
            v-model="nivelSelecionado" 
            :value="classificacao.id" 
            @click.stop
          />
          <span class="marcador-radio"></span>
        </div>
      </div>
    </div>

    <div class="acoes-classificacao">
      <button @click="voltar" class="botao-acao botao-voltar">
        <i class="fas fa-arrow-left"></i> Voltar
      </button>
      <button @click="limparSelecao" class="botao-acao botao-limpar" :disabled="!nivelSelecionado">
        <i class="fas fa-eraser"></i> Limpar
      </button>
      <button @click="enviarClassificacao" class="botao-acao botao-enviar" :disabled="!nivelSelecionado">
        <i class="fas fa-check"></i> Confirmar
      </button>
    </div>
  </div>
</template>

<script>
import { useTriagem } from '@/stores/triagem'

export default {
  name: 'ClassificacaoRisco',
  
  data() {
    return {
      nivelSelecionado: null,
      classificacoes: [],
      carregando: false,
      erro: null
    }
  },
  
  async mounted() {
    await this.carregarClassificacoes()
  },
  
  methods: {
    async carregarClassificacoes() {
      this.carregando = true
      this.erro = null
      
      try {
        const response = await fetch('http://localhost:3001/api/classificacoes_risco')
        
        if (!response.ok) {
          throw new Error(`Erro HTTP: ${response.status}`)
        }
        
        this.classificacoes = await response.json()
        console.log('Dados da API:', this.classificacoes) 
      } catch (error) {
        console.error('Erro ao carregar classificações:', error)
        this.erro = error.message || 'Erro ao carregar classificações'
      } finally {
        this.carregando = false
      }
    },
    
    selecionarNivel(id) {
      this.nivelSelecionado = id
    },
    
    limparSelecao() {
      this.nivelSelecionado = null
    },
    
    voltar() {
      this.$router.push('/menu/prioridades-comorbidades')
    },
    
    async enviarClassificacao() {
      if (!this.nivelSelecionado) return

      const triagemStore = useTriagem()
      triagemStore.carregarEnfermeiroLogado()
      
      const classificacaoSelecionada = this.classificacoes.find(c => c.id === this.nivelSelecionado)
      
      if (!classificacaoSelecionada) {
        console.error('Classificação selecionada não encontrada')
        return
      }
      
      // DEBUG: Verifique os dados que estão vindo da API
      console.log('Dados da classificação selecionada:', classificacaoSelecionada)
      
      await triagemStore.definirClassificacao({
        id: classificacaoSelecionada.id, // ← Garanta que o ID está sendo passado
        nivel: classificacaoSelecionada.nivel,
        nome_nivel: classificacaoSelecionada.nome_nivel,
        descricao: classificacaoSelecionada.descricao,
        tempo_atendimento: classificacaoSelecionada.tempo_atendimento, // ← Campo do banco
        exemplos: classificacaoSelecionada.exemplos || [],
        classificador: triagemStore.enfermeiro.nome,
        corenClassifier: triagemStore.enfermeiro.coren
      })

      this.$router.push('/menu/resumo-final')
    }
  }
}
</script>

<style scoped>
.classificacao-container {
  max-width: 900px;
  margin: 0 auto;
  padding: 20px;
}

/* Cabeçalho */
.cabecalho-classificacao {
  text-align: center;
  margin-bottom: 25px;
}
.titulo-classificacao {
  font-size: 24px;
  color: #2c3e50;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}
.subtitulo-classificacao {
  font-size: 14px;
  color: #7f8c8d;
}

/* Estado: carregando e erro */
.carregando-container,
.erro-container {
  text-align: center;
  padding: 20px;
}
.carregando-container {
  color: #3498db;
}
.erro-container {
  color: #e74c3c;
}
.botao-tentar-novamente {
  margin-top: 10px;
  padding: 8px 16px;
  background: #3498db;
  color: #fff;
  border: none;
  border-radius: 6px;
  cursor: pointer;
}
.botao-tentar-novamente:hover {
  background: #2980b9;
}

/* Cards de classificação */
.opcoes-classificacao {
  display: flex;
  flex-direction: column;
  gap: 16px;
  margin-bottom: 20px;
}
.card-classificacao {
  display: flex;
  align-items: flex-start;
  padding: 16px;
  border-radius: 10px;
  background: #fff;
  border: 1px solid #e0e0e0;
  cursor: pointer;
  transition: all 0.2s;
  position: relative;
}
.card-classificacao:hover {
  border-color: #3498db;
  box-shadow: 0 2px 8px rgba(52,152,219,0.15);
}
.card-classificacao.selecionado {
  border: 2px solid #3498db;
  box-shadow: 0 4px 10px rgba(52,152,219,0.2);
}

/* Cores de níveis */
.vermelho { border-left: 6px solid #e74c3c; }
.laranja { border-left: 6px solid #e67e22; }
.amarelo { border-left: 6px solid #f1c40f; }
.verde   { border-left: 6px solid #2ecc71; }
.azul    { border-left: 6px solid #3498db; }

/* Conteúdo */
.conteudo-classificacao {
  flex: 1;
  margin-left: 12px;
}
.cabecalho-card {
  display: flex;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 6px;
  margin-bottom: 8px;
}
.nivel-classificacao {
  font-size: 16px;
  font-weight: 600;
}
.tempo-atendimento {
  font-size: 14px;
  color: #7f8c8d;
  display: flex;
  align-items: center;
  gap: 4px;
}
.descricao-classificacao {
  font-size: 14px;
  color: #2c3e50;
  margin-bottom: 8px;
  line-height: 1.4;
}
.exemplos-container {
  background: #f8fafc;
  border-radius: 6px;
  padding: 10px;
}
.titulo-exemplos {
  font-size: 14px;
  font-weight: 600;
  margin-bottom: 6px;
  display: flex;
  align-items: center;
  gap: 4px;
}
.exemplos-classificacao {
  font-size: 14px;
  color: #2c3e50;
  margin: 0;
  padding-left: 18px;
}
.exemplos-classificacao li {
  margin-bottom: 4px;
  display: flex;
  align-items: center;
  gap: 4px;
}

/* Seletor radio */
.seletor-radio {
  margin-left: 12px;
  position: relative;
  min-width: 22px;
}
.seletor-radio input {
  display: none;
}
.marcador-radio {
  height: 20px;
  width: 20px;
  border: 2px solid #ccc;
  border-radius: 50%;
  display: inline-block;
  position: relative;
}
.seletor-radio input:checked + .marcador-radio {
  border-color: #3498db;
  background: #3498db;
}
.seletor-radio input:checked + .marcador-radio::after {
  content: "";
  position: absolute;
  top: 5px;
  left: 5px;
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #fff;
}

/* Botões */
.acoes-classificacao {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding-top: 15px;
  border-top: 1px solid #ecf0f1;
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
  .card-classificacao {
    flex-direction: column;
  }
  .conteudo-classificacao {
    margin-left: 0;
    margin-top: 12px;
  }
  .seletor-radio {
    align-self: flex-end;
    margin-top: 10px;
  }
  .acoes-classificacao {
    flex-direction: column;
  }
  .botao-acao {
    width: 100%;
    justify-content: center;
  }
}
</style>

import { defineStore } from 'pinia'

export const useTriagem = defineStore('triagem', {
  state: () => ({
    enfermeiro: {
      id: null,
      nome: '',
      coren: '',
      email: '',
      login: '',
      instituicao: '',
    },

    paciente: {
      id: null,
      nome: '',
      cpf: '',
      data_nascimento: '',
      idade: null,
      sexo: '',
      endereco: '',
      cidade: '',
      uf: '',
      telefone: '',
      email: '',
      nomeSocial: '',
      nomeMae: '',
      nomePai: '',
      racaCor: '',
      orientacaoSexual: '',
      identidadeGenero: '',
      instituicao: '',
      createdAt: null
    },

    sinaisVitais: {
      temperatura: null,
      frequenciaCardiaca: null,
      pressaoArterial: '',
      frequenciaRespiratoria: null,
      saturacao: null,
      glicemia: null,
      medidaEm: null,
      glasgowOcular: null,
      glasgowVerbal: null,
      glasgowMotora: null,
      glasgowTotal: null,
      escalaDor: null
    },

    sintomas: {
      opcoes: [],
      selecionados: [],
      outrosSintomas: '',
      observacoesClinicas: ''
    },

    prioridades: {
      opcoes: {},
      selecionadas: []
    },

    comorbidades: {
      opcoes: {},
      selecionadas: []
    },

    alergias: {
      possuiAlergia: false,
      descricao: ''
    },

    classificacao: {
      id: null,
      nivel: '',
      descricao: '',
      tempoAtendimento: '',
      exemplos: [],
      classificador: '',
      corenClassifier: '',
      dataClassificacao: null
    }
  }),

  actions: {
    carregarEnfermeiroLogado() {
      const usuario = JSON.parse(localStorage.getItem('usuario'))
      if (usuario) {
        this.enfermeiro = {
          id: usuario.id || null,
          nome: usuario.nome || 'Enfermeiro não identificado',
          coren: usuario.coren || 'COREN não informado',
          email: usuario.email || '',
          login: usuario.login || '',
          instituicao: usuario.instituicao || 'Instituição não informada'
        }
      }
    },

    setEnfermeiro(dados) {
      if (!dados) return
      this.enfermeiro = {
        id: dados.id || null,
        ...this.enfermeiro,
        ...dados
      }
    },

    setPaciente(dados) {
      if (!dados) return

      this.paciente = {
        id: dados.id || null,
        ...this.paciente,
        ...dados,
        idade: dados.data_nascimento ? this.calcularIdade(dados.data_nascimento) : null,
        createdAt: dados.createdAt || new Date().toISOString()
      }
    },

    calcularIdade(dataNascimento) {
      if (!dataNascimento) return null
      const diff = Date.now() - new Date(dataNascimento).getTime()
      return Math.abs(new Date(diff).getUTCFullYear() - 1970)
    },

    setSinaisVitais(dados) {
      if (!dados) return

      let pressaoArterial = dados.pressaoArterial
      if (pressaoArterial && !pressaoArterial.includes('/')) {
        pressaoArterial = `${pressaoArterial}/80`
      }

      const ocular = Number(dados.glasgowOcular) || null
      const verbal = Number(dados.glasgowVerbal) || null
      const motora = Number(dados.glasgowMotora) || null
      const totalGlasgow = (ocular || 0) + (verbal || 0) + (motora || 0)

      this.sinaisVitais = {
        ...this.sinaisVitais,
        ...dados,
        pressaoArterial,
        glasgowOcular: ocular,
        glasgowVerbal: verbal,
        glasgowMotora: motora,
        glasgowTotal: totalGlasgow,
        medidaEm: new Date().toISOString()
      }
    },

    setSintomasCompletos({ selecionados, outrosSintomas, observacoesClinicas }) {
      this.sintomas.selecionados = selecionados
      this.sintomas.outrosSintomas = outrosSintomas
      this.sintomas.observacoesClinicas = observacoesClinicas
    },

    setPrioridadesSelecionadas(prioridades) {
      this.prioridades.selecionadas = Array.isArray(prioridades) ? prioridades : []
    },

    setComorbidadesSelecionadas(comorbidades) {
      this.comorbidades.selecionadas = Array.isArray(comorbidades) ? comorbidades : []
    },

    definirAlergias({ possuiAlergia, descricao = '' }) {
      this.alergias = {
        possuiAlergia: !!possuiAlergia,
        descricao: possuiAlergia ? (descricao || 'Alergia não especificada') : ''
      }
    },

    definirClassificacao({ id = null, nivel, descricao, tempoAtendimento, classificador, corenClassifier }) {
      const classificacoes = {
        vermelho: {
          descricao: descricao || 'Emergência - Risco de morte iminente',
          tempoAtendimento: tempoAtendimento || 'Atendimento imediato (0-10 min)',
          exemplos: ['Parada cardiorrespiratória', 'Hemorragia incontrolável', 'Trauma grave']
        },
        laranja: {
          descricao: descricao || 'Muito Urgente - Condição potencialmente grave',
          tempoAtendimento: tempoAtendimento || 'Atendimento em até 10 minutos',
          exemplos: ['Dor torácica suspeita', 'Desidratação grave', 'Fraturas expostas']
        },
        amarelo: {
          descricao: descricao || 'Urgente - Condição aguda não grave',
          tempoAtendimento: tempoAtendimento || 'Atendimento em até 1 hora',
          exemplos: ['Cólica renal', 'Hipertensão sintomática', 'Febre alta persistente']
        },
        verde: {
          descricao: descricao || 'Pouco Urgente - Condição não aguda',
          tempoAtendimento: tempoAtendimento || 'Atendimento em até 2 horas',
          exemplos: ['Dor de ouvido', 'Diarréia sem desidratação', 'Traumas leves']
        },
        azul: {
          descricao: descricao || 'Não Urgente - Condição crônica',
          tempoAtendimento: tempoAtendimento || 'Atendimento em até 4 horas',
          exemplos: ['Renovação de receitas', 'Exames de rotina', 'Acompanhamento de doenças crônicas']
        }
      }

      this.classificacao = {
        id,
        nivel,
        ...classificacoes[nivel],
        classificador: classificador || this.enfermeiro.nome,
        corenClassifier: corenClassifier || this.enfermeiro.coren,
        dataClassificacao: new Date().toISOString()
      }
    },

    // NOVA FUNÇÃO: Limpa apenas os dados da triagem, mantendo o enfermeiro logado

    limparDadosTriagem() {
      // Mantém os dados do enfermeiro
      const enfermeiroAtual = { ...this.enfermeiro }
      
      // Reseta todos os outros dados
      this.$reset()
      
      // Restaura os dados do enfermeiro
      this.enfermeiro = enfermeiroAtual
      
      console.log('Dados da triagem limpos, mantendo enfermeiro logado')
    },

    resetAll() {
      this.$reset()
      this.carregarEnfermeiroLogado()
    },

    // Função para gerar payload específico para envio ao Rails
    generateApiPayload(pdfData = null) {
      return {
        paciente_fake_id: this.paciente.id,
        enfermeiro_id: this.enfermeiro.id,
        classificacao_risco_id: this.classificacao.id,
        sinais_vitais_attributes: { ...this.sinaisVitais },
        sintomas_triagem_attributes: {
          selecionados: this.sintomas.selecionados,
          outros_sintomas: this.sintomas.outrosSintomas,
          observacoes_clinicas: this.sintomas.observacoesClinicas
        },
        prioridades_triagem_attributes: { selecionadas: this.prioridadesAtivas },
        comorbidades_triagem_attributes: { selecionadas: this.comorbidadesAtivas },
        alergias_triagem_attributes: {
          possui_alergia: !!this.alergias.possuiAlergia,
          descricao: this.alergias.descricao
        },
        ...(pdfData ? {
          pdf_data: pdfData.base64,
          pdf_file_name: pdfData.filename,
          pdf_content_type: 'application/pdf',
          pdf_file_size: pdfData.size
        } : {})
      }
    },

    generateReportData() {
      return {
        enfermeiro: this.enfermeiro,
        paciente: this.paciente,
        sinaisVitais: this.sinaisVitais,
        sintomas: {
          selecionados: this.sintomas.selecionados,
          outrosSintomas: this.sintomas.outrosSintomas,
          observacoesClinicas: this.sintomas.observacoesClinicas
        },
        prioridades: this.prioridadesAtivas,
        comorbidades: this.comorbidadesAtivas,
        alergias: this.alergias,
        classificacao: this.classificacao,
        metadata: {
          createdAt: this.paciente.createdAt,
          updatedAt: new Date().toISOString()
        }
      }
    }
  },

  getters: {
    prioridadesAtivas: (state) => {
      return state.prioridades.selecionadas.map(p => {
        if (typeof p === 'string') return p
        return p.texto || p.descricao || 'Prioridade não especificada'
      })
    },

    comorbidadesAtivas: (state) => {
      return state.comorbidades.selecionadas.map(c => {
        if (typeof c === 'string') return c
        return c.texto || c.descricao || 'Comorbidade não especificada'
      })
    },

    idadePaciente: (state) => {
      return state.paciente.idade || 
        (state.paciente.data_nascimento ? 
          (() => {
            const diff = Date.now() - new Date(state.paciente.data_nascimento).getTime()
            return Math.abs(new Date(diff).getUTCFullYear() - 1970)
          })() 
        : null)
    },

    pressaoArterialFormatada: (state) => {
      if (!state.sinaisVitais.pressaoArterial) return '--/--'
      return state.sinaisVitais.pressaoArterial.includes('/')
        ? state.sinaisVitais.pressaoArterial
        : `${state.sinaisVitais.pressaoArterial}/--`
    },

    totalGlasgow: (state) => {
      const { glasgowOcular, glasgowVerbal, glasgowMotora } = state.sinaisVitais
      return (Number(glasgowOcular) || 0) + (Number(glasgowVerbal) || 0) + (Number(glasgowMotora) || 0)
    }
  }
})
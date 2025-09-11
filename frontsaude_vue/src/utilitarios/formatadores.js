import { MAPA_SINTOMAS } from '../constantes/sintomas.js'
import { MAPA_PRIORIDADES } from '../constantes/prioridades.js'
import { MAPA_COMORBIDADES } from '../constantes/comorbidades.js'

export const formatarSintoma = (sintoma) => {
  return MAPA_SINTOMAS[sintoma] || sintoma.replace(/_/g, ' ')
}

export const formatarPrioridade = (prioridade) => {
  return MAPA_PRIORIDADES[prioridade]?.texto || prioridade
}

export const formatarComorbidade = (comorbidade) => {
  return MAPA_COMORBIDADES[comorbidade]?.texto || comorbidade
}

export const formatarValor = (valor, tipo) => {
  const formatadores = {
    sintoma: formatarSintoma,
    prioridade: formatarPrioridade,
    comorbidade: formatarComorbidade
  }
  
  return formatadores[tipo]?.(valor) || valor
}

export const obterIconePrioridade = (prioridade) => {
  return MAPA_PRIORIDADES[prioridade]?.icone || ''
}

export const obterIconeComorbidade = (comorbidade) => {
  return MAPA_COMORBIDADES[comorbidade]?.icone || ''
}
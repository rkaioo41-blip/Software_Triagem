import { computed } from 'vue'
import { 
  formatarSintoma, 
  formatarPrioridade, 
  formatarComorbidade,
  formatarValor,
  obterIconePrioridade,
  obterIconeComorbidade
} from '../utilitarios/formatadores'

export function useFormatadores() {
  const sintoma = (valor) => computed(() => formatarSintoma(valor))
  const prioridade = (valor) => computed(() => formatarPrioridade(valor))
  const comorbidade = (valor) => computed(() => formatarComorbidade(valor))
  const valor = (valor, tipo) => computed(() => formatarValor(valor, tipo))
  const iconePrioridade = (valor) => computed(() => obterIconePrioridade(valor))
  const iconeComorbidade = (valor) => computed(() => obterIconeComorbidade(valor))

  return {
    sintoma,
    prioridade,
    comorbidade,
    valor,
    iconePrioridade,
    iconeComorbidade
  }
}
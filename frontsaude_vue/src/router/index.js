import { createRouter, createWebHistory } from 'vue-router'

import TelaLogin from '../components/TelaLogin.vue'
import TelaCadastro from '../components/TelaCadastro.vue'

import MenuPrincipal from '@/views/MenuPrincipal.vue'
import MenuInicial from '@/components/MenuInicial.vue' 
import DadosPaciente from '../components/Triagem/DadosPaciente.vue'
import SinaisVitais from '../components/Triagem/SinaisVitais.vue'
import SeletorSintomas from '../components/Triagem/SeletorSintomas.vue'
import PrioridadesComorbidades from '../components/Triagem/PrioridadesComorbidades.vue'
import ClassificacaoRisco from '../components/Triagem/ClassificacaoRisco.vue'
import ResumoFinal from '../components/ResumoFinal.vue'
import DadosRelatorios from '../components/Historico/DadosRelatorios.vue'
import PerfilUsuario from '../components/PerfilUsuario.vue'
import RecuperarSenha from '../components/RecuperarSenha.vue'

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    name: 'Login',
    component: TelaLogin
  },
  {
    path: '/cadastro',
    name: 'Cadastro',
    component: TelaCadastro
  },
  {
    path: '/recuperar-senha',
    name: 'RecuperarSenha',
    component: RecuperarSenha
  },
  {
    path: '/menu',
    component: MenuPrincipal,
    meta: { requiresAuth: true },
    children: [
      {
        path: '',
        name: 'MenuInicial',
        component: MenuInicial 
      },
      {
        path: 'triagem-dados-paciente',
        name: 'TriagemDadosPaciente',
        component: DadosPaciente
      },
      {
        path: 'sinais-vitais',
        name: 'SinaisVitais',
        component: SinaisVitais
      },
      {
        path: 'selecao-sintomas',
        name: 'SelecaoSintomas',
        component: SeletorSintomas
      },
      {
        path: 'prioridades-comorbidades',
        name: 'PrioridadesComorbidades',
        component: PrioridadesComorbidades
      },
      {
        path: 'classificacao',
        name: 'ClassificacaoRisco',
        component: ClassificacaoRisco
      },
      {
        path: 'resumo-final',
        name: 'ResumoFinal',
        component: ResumoFinal
      },
      {
        path: 'relatorios',
        name: 'DadosRelatorios',
        component: DadosRelatorios
      },
      {
        path: 'perfil',
        name: 'PerfilUsuario',
        component: PerfilUsuario
      },
    ]
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/login'
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  console.log('Navegando de:', from.path, 'para:', to.path)
  const token = localStorage.getItem('token')

  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (!token) {
      console.log('Redirecionando para login - token não encontrado')
      next('/login')
    } else {
      console.log('Acesso autorizado - token presente')
      next()
    }
  } else {
    next()
  }
})

export default router
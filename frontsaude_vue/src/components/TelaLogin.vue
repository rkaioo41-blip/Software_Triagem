<template>
  <div class="container-login-unificado">
    <div class="cartao-login">
      <div class="cabecalho-login">
        <div class="logo-container">
          <img src="@/assets/logo_sistema.png" alt="Logo Sistema" class="logo-sistema" />
        </div>
        <h1 class="titulo-login">Sistema de Triagem</h1>
        <p class="subtitulo-login">Acesso restrito a profissionais de saúde</p>
      </div>

      <form @submit.prevent="realizarLogin" class="formulario-login">
        <div class="grupo-formulario">
          <label for="identificador" class="rotulo-formulario">COREN ou E-mail</label>
          <input
            type="text"
            id="identificador"
            v-model="identificador"
            class="entrada-formulario"
            placeholder="Digite seu COREN ou e-mail"
            required
          />
        </div>

        <div class="grupo-formulario">
          <label for="senha" class="rotulo-formulario">Senha</label>
          <input
            type="password"
            id="senha"
            v-model="senha"
            class="entrada-formulario"
            placeholder="••••••••"
            required
          />
        </div>

        <div class="opcoes-formulario">
          <label class="lembrar-senha">
            <input type="checkbox" v-model="lembrarMe" />
            <span>Lembrar de mim</span>
          </label>
          <router-link to="/recuperar-senha" class="esqueci-senha">
            Esqueceu a senha?
          </router-link>
        </div>

        <div v-if="mensagemErro" class="mensagem-erro">
          <i class="fas fa-exclamation-circle"></i> {{ mensagemErro }}
        </div>

        <button type="submit" class="botao-login" :disabled="carregando">
          <span v-if="!carregando">Entrar</span>
          <span v-else class="carregando-spinner">
            <i class="fas fa-spinner fa-spin"></i> Autenticando...
          </span>
        </button>
      </form>

      <div class="rodape-login">
        <p>
          É novo aqui?
          <router-link to="/cadastro" class="link-cadastro">
            Solicite seu cadastro
          </router-link>
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import api from "@/axios";
import { ofuscarSenha } from "@/utilitarios/ofuscacaoSenha";

export default {
  data() {
    return {
      identificador: "",
      senha: "",
      lembrarMe: false,
      carregando: false,
      mensagemErro: ""
    };
  },
  methods: {
    async realizarLogin() {
      this.carregando = true;
      this.mensagemErro = "";

      try {
        const { senhaOfuscada } = ofuscarSenha(this.senha);

        const response = await api.post("/login", {
          identificador: this.identificador,
          password: senhaOfuscada
        });

        const token = response.data.token;
        const enfermeiro = response.data.enfermeiro;

        localStorage.setItem("token", token);
        localStorage.setItem("usuario", JSON.stringify(enfermeiro));

        this.$router.push("/menu");
      } catch (error) {
        this.mensagemErro =
          error.response?.data?.erro ||
          "Erro ao autenticar. Verifique suas credenciais.";
        console.error("Erro no login:", error);
      } finally {
        this.carregando = false;
      }
    }
  }
}
</script>





<style scoped>
/* Variáveis de cores */
:root {
  --cor-primaria: #2E86AB;    /* Azul profissional */
  --cor-secundaria: #27AE60;  /* Verde profissional */
  --cor-fundo: #F8F9FA;       /* Cinza muito claro para o fundo */
  --cor-texto: #2C3E50;       /* Azul escuro para texto */
  --cor-texto-secundario: #7F8C8D; /* Cinza para texto secundário */
  --cor-borda: #DCE2E6;       /* Cinza claro para bordas */
  --cor-erro: #E74C3C;        /* Vermelho para mensagens de erro */
  --sombra-suave: 0 4px 12px rgba(0, 0, 0, 0.08);
  --transicao-padrao: all 0.3s ease;
}

/* Layout unificado */
.container-login-unificado {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: var(--cor-fundo);
  padding: 20px;
}

/* Cartão de login */
.cartao-login {
  width: 100%;
  max-width: 440px;
  background: white;
  border-radius: 12px;
  box-shadow: var(--sombra-suave);
  padding: 40px 35px;
  animation: fadeIn 0.5s ease;
}

.logo-container {
  text-align: center;
  margin-bottom: 20px;
}

.logo-sistema {
  max-width: 90px;
  height: auto;
}

.cabecalho-login {
  text-align: center;
  margin-bottom: 30px;
}

.titulo-login {
  font-size: 1.8rem;
  font-weight: 600;
  color: var(--cor-texto);
  margin-bottom: 10px;
}

.subtitulo-login {
  font-size: 0.95rem;
  color: var(--cor-texto-secundario);
  margin: 0;
}

/* Formulário */
.formulario-login {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.grupo-formulario {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.rotulo-formulario {
  font-size: 0.9rem;
  font-weight: 500;
  color: var(--cor-texto);
}

.entrada-formulario {
  padding: 14px 16px;
  border: 1px solid var(--cor-borda);
  border-radius: 8px;
  font-size: 0.95rem;
  transition: var(--transicao-padrao);
  background-color: #fff;
}

.entrada-formulario:focus {
  outline: none;
  border-color: var(--cor-primaria);
  box-shadow: 0 0 0 3px rgba(46, 134, 171, 0.15);
}

.entrada-formulario::placeholder {
  color: #A0AEC0;
}

/* Opções do formulário */
.opcoes-formulario {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.85rem;
  margin: 10px 0;
}

.lembrar-senha {
  display: flex;
  align-items: center;
  gap: 6px;
  color: var(--cor-texto-secundario);
  cursor: pointer;
}

.lembrar-senha input {
  accent-color: var(--cor-primaria);
}

.esqueci-senha {
  color: var(--cor-primaria);
  text-decoration: none;
  transition: var(--transicao-padrao);
  font-weight: 500;
}

.esqueci-senha:hover {
  color: var(--cor-secundaria);
}

/* Mensagem de erro */
.mensagem-erro {
  background-color: rgba(231, 76, 60, 0.1);
  color: var(--cor-erro);
  padding: 12px 16px;
  border-radius: 8px;
  font-size: 0.9rem;
  display: flex;
  align-items: center;
  gap: 8px;
  margin: 10px 0;
}

/* Botão de login */
.botao-login {
  padding: 14px;
  background: linear-gradient(135deg, var(--cor-primaria) 0%, #256E8F 100%);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: var(--transicao-padrao);
  margin-top: 15px;
  box-shadow: 0 2px 4px rgba(46, 134, 171, 0.2);
}

.botao-login:hover:not(:disabled) {
  background: linear-gradient(135deg, #256E8F 0%, #1E5A75 100%);
  box-shadow: 0 4px 8px rgba(46, 134, 171, 0.3);
  transform: translateY(-1px);
}

.botao-login:active:not(:disabled) {
  transform: translateY(0);
}

.botao-login:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  transform: none;
}

.carregando-spinner {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

/* Rodapé */
.rodape-login {
  text-align: center;
  margin-top: 25px;
  padding-top: 20px;
  border-top: 1px solid var(--cor-borda);
  font-size: 0.9rem;
  color: var(--cor-texto-secundario);
}

.link-cadastro {
  color: var(--cor-secundaria);
  text-decoration: none;
  font-weight: 600;
  transition: var(--transicao-padrao);
}

.link-cadastro:hover {
  color: #219653;
  text-decoration: underline;
}

/* Animações */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(15px); }
  to { opacity: 1; transform: translateY(0); }
}

/* Responsividade */
@media (max-width: 480px) {
  .cartao-login {
    padding: 30px 25px;
    max-width: 100%;
  }

  .titulo-login {
    font-size: 1.6rem;
  }

  .subtitulo-login {
    font-size: 0.9rem;
  }
  
  .opcoes-formulario {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .esqueci-senha {
    margin-left: auto;
  }
}
</style>
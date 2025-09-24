<template>
  <div class="container-recuperar-senha">
    <div class="cartao-recuperar">
      <div class="logo-container">
        <img src="@/assets/logo_sistema.png" alt="Logo Sistema" class="logo-sistema" />
      </div>

      <h1 class="titulo-recuperar">{{ token ? "Redefinir Senha" : "Recuperar Senha" }}</h1>
      <p v-if="!token" class="subtitulo-recuperar">
        Digite seu COREN ou e-mail para receber as instruções de redefinição de senha
      </p>

      <!-- FORMULÁRIO DE SOLICITAR TOKEN -->
      <div v-if="!token">
        <form @submit.prevent="enviarSolicitacao" class="formulario-recuperar">
          <input type="text" v-model="identificador" placeholder="Digite seu COREN ou e-mail" required />
          <button type="submit" :disabled="carregando">{{ carregando ? "Enviando..." : "Enviar" }}</button>
        </form>
      </div>

      <!-- FORMULÁRIO DE NOVA SENHA -->
      <div v-else>
        <form @submit.prevent="redefinirSenha" class="formulario-recuperar">
          <div class="grupo-duplo">
            <div class="grupo-formulario">
              <label class="rotulo-formulario">Nova Senha</label>
              <input type="password" v-model="novaSenha" class="entrada-formulario" placeholder="••••••••" required />
            </div>
            <div class="grupo-formulario">
              <label class="rotulo-formulario">Confirmar Senha</label>
              <input type="password" v-model="confirmaSenha" class="entrada-formulario" placeholder="••••••••" required />
            </div>
          </div>
          <button type="submit" :disabled="carregando" class="botao-principal">
            <span v-if="!carregando">Atualizar senha</span>
            <span v-else class="carregando-spinner"><i class="fas fa-spinner fa-spin"></i> Processando...</span>
          </button>
        </form>
      </div>

      <div v-if="mensagem" :class="['mensagem-retorno', sucesso ? 'sucesso' : 'erro']">
        {{ mensagem }}
      </div>

      <router-link to="/login" class="link-voltar">Voltar para o login</router-link>
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
      novaSenha: "",
      confirmaSenha: "",
      token: "",
      carregando: false,
      mensagem: "",
      sucesso: false
    };
  },
  mounted() {
    // Corrigir a extração do token da URL
    const urlParams = new URLSearchParams(window.location.search);
    const tokenFromUrl = urlParams.get("token");
    
    if (tokenFromUrl) {
      // Decodificar o token se necessário (pode estar encoded na URL)
      this.token = decodeURIComponent(tokenFromUrl);
      console.log("Token extraído:", this.token);
    }
  },
  methods: {
    async enviarSolicitacao() {
      this.carregando = true;
      this.mensagem = "";
      try {
        const response = await api.post("/recuperar_senhas", { identificador: this.identificador });
        this.sucesso = true;
        this.mensagem = response.data.mensagem;
        this.identificador = "";
      } catch (err) {
        this.sucesso = false;
        this.mensagem = err.response?.data?.erro || "Erro ao solicitar recuperação.";
      } finally {
        this.carregando = false;
      }
    },

    async redefinirSenha() {
      if (this.novaSenha !== this.confirmaSenha) {
        this.sucesso = false;
        this.mensagem = "As senhas não coincidem.";
        return;
      }

      if (!this.token) {
        this.sucesso = false;
        this.mensagem = "Token inválido ou expirado.";
        return;
      }

      this.carregando = true;
      try {
        // 🔐 Usar a mesma lógica do cadastro através do utilitário
        const { senhaOfuscada } = ofuscarSenha(this.novaSenha);

        console.log("Enviando token:", this.token);
        
        const response = await api.put("/recuperar_senhas", {
          token: this.token,
          enfermeiro: {
            password: senhaOfuscada
          }
        });

        this.sucesso = true;
        this.mensagem = response.data.mensagem || "Senha redefinida com sucesso!";
        this.novaSenha = "";
        this.confirmaSenha = "";
        
        // Redirecionar para login após 3 segundos
        setTimeout(() => {
          this.$router.push("/login");
        }, 3000);
        
      } catch (err) {
        this.sucesso = false;
        const errorMsg = err.response?.data?.erro;
        
        if (errorMsg?.includes("token") || errorMsg?.includes("Token")) {
          this.mensagem = "Token inválido ou expirado. Solicite uma nova recuperação de senha.";
          this.token = ""; // Limpar token inválido
        } else {
          this.mensagem = errorMsg || "Erro ao atualizar senha.";
        }
      } finally {
        this.carregando = false;
      }
    }
  }
};
</script>

<style scoped>
.container-recuperar-senha {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
}

.cartao-recuperar {
  background: white;
  padding: 40px;
  border-radius: 15px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
  width: 100%;
  max-width: 450px;
  text-align: center;
}

.logo-container {
  margin-bottom: 20px;
}

.logo-sistema {
  max-width: 120px;
  height: auto;
}

.titulo-recuperar {
  color: #333;
  margin-bottom: 10px;
  font-size: 24px;
}

.subtitulo-recuperar {
  color: #666;
  margin-bottom: 30px;
  line-height: 1.5;
}

.formulario-recuperar {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.grupo-duplo {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 15px;
}

.grupo-formulario {
  text-align: left;
}

.rotulo-formulario {
  display: block;
  margin-bottom: 5px;
  color: #333;
  font-weight: 500;
}

.entrada-formulario {
  width: 100%;
  padding: 12px 15px;
  border: 2px solid #e1e5e9;
  border-radius: 8px;
  font-size: 14px;
  transition: border-color 0.3s;
}

.entrada-formulario:focus {
  outline: none;
  border-color: #667eea;
}

.botao-principal {
  width: 100%;
  padding: 12px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: opacity 0.3s;
}

.botao-principal:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.botao-principal:hover:not(:disabled) {
  opacity: 0.9;
}

.carregando-spinner {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.mensagem-retorno {
  padding: 12px;
  border-radius: 8px;
  margin: 20px 0;
  font-weight: 500;
}

.mensagem-retorno.sucesso {
  background-color: #d4edda;
  color: #155724;
  border: 1px solid #c3e6cb;
}

.mensagem-retorno.erro {
  background-color: #f8d7da;
  color: #721c24;
  border: 1px solid #f5c6cb;
}

.link-voltar {
  display: inline-block;
  margin-top: 20px;
  color: #667eea;
  text-decoration: none;
  font-weight: 500;
}

.link-voltar:hover {
  text-decoration: underline;
}

/* Responsividade */
@media (max-width: 480px) {
  .cartao-recuperar {
    padding: 30px 20px;
  }
  
  .grupo-duplo {
    grid-template-columns: 1fr;
    gap: 10px;
  }
}
</style>
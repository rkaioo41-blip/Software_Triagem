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
          <input type="password" v-model="novaSenha" placeholder="Nova senha" required />
          <input type="password" v-model="confirmaSenha" placeholder="Confirme a senha" required />
          <button type="submit" :disabled="carregando">{{ carregando ? "Processando..." : "Atualizar senha" }}</button>
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
import CryptoJS from "crypto-js";

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
    const urlParams = new URLSearchParams(window.location.search);
    this.token = urlParams.get("token") || "";
  },
  methods: {
    inverterString(str) {
      return str.split("").reverse().join("");
    },

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


      this.carregando = true;
      try {
        // 🔐 Mesma lógica do cadastro: inverter + SHA-256
        const senhaInvertida = this.inverterString(this.novaSenha);
        const senhaHash = CryptoJS.SHA256(senhaInvertida).toString();

        const response = await api.put("/recuperar_senhas", {
          token: this.token,
          password: senhaHash
        });

        this.sucesso = true;
        this.mensagem = response.data.mensagem;
        this.novaSenha = "";
        this.confirmaSenha = "";
        this.token = "";
      } catch (err) {
        this.sucesso = false;
        this.mensagem = err.response?.data?.erro || "Erro ao atualizar senha.";
      } finally {
        this.carregando = false;
      }
    }
  }
};
</script>

<style scoped>
/* Mantém o mesmo estilo do cadastro, apenas adaptando classes */
.container-recuperar-senha {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
}
.cartao-recuperar {
  background: #fff;
  padding: 2rem;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  max-width: 420px;
  width: 100%;
  text-align: center;
}
.titulo-recuperar {
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
}
.subtitulo-recuperar {
  font-size: 0.9rem;
  color: #555;
  margin-bottom: 1.5rem;
}
.formulario-recuperar {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}
.entrada-formulario {
  padding: 0.75rem;
  border-radius: 8px;
  border: 1px solid #ccc;
  width: 100%;
}
button {
  background: #2a9d8f;
  color: white;
  border: none;
  padding: 0.75rem;
  border-radius: 8px;
  cursor: pointer;
  font-weight: bold;
  transition: 0.3s;
}
button:hover {
  background: #21867a;
}
.mensagem-retorno {
  padding: 0.75rem;
  border-radius: 8px;
  font-size: 0.9rem;
  text-align: left;
}
.mensagem-retorno.sucesso {
  background: #e6ffed;
  color: #2d7a46;
  border: 1px solid #a6f0b6;
}
.mensagem-retorno.erro {
  background: #ffe6e6;
  color: #a12b2b;
  border: 1px solid #f0a6a6;
}
.link-voltar {
  margin-top: 1rem;
  display: inline-block;
  color: #2a9d8f;
  text-decoration: none;
}
.link-voltar:hover {
  text-decoration: underline;
}
.logo-sistema {
  width: 40%;
  max-width: 150px;
  height: auto;
  margin-bottom: 1rem;
}
</style>

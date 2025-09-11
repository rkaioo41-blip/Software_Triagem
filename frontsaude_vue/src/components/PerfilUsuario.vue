<template>
  <div class="perfil-card">
    <h1 class="perfil-titulo">Meu Perfil</h1>

    <div v-if="usuario" class="perfil-info">
      <p><span>👤 Nome:</span> {{ usuario.nome }}</p>
      <p><span>📧 Email:</span> {{ usuario.email }}</p>
      <p><span>🆔 COREN:</span> {{ usuario.coren }} - {{ usuario.uf }}</p>
      <p><span>🏥 Instituição:</span> {{ usuario.instituicao }}</p>
      <p><span>🎂 Data de Nascimento:</span> {{ formatarData(usuario.data_nascimento || usuario.dataNascimento) }}</p>
      <p><span>⚧ Sexo:</span> {{ capitalize(usuario.sexo) }}</p>
      <p><span>🆔 UF:</span> {{ capitalize(usuario.uf) }}</p>

      <button class="botao-trocar-senha" @click="trocarSenha">
        🔒 Trocar Senha
      </button>
    </div>

    <div v-else class="perfil-vazio">
      <p>Nenhuma informação encontrada. Faça login novamente.</p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'PerfilUsuario',
  data() {
    return { usuario: null };
  },
  mounted() {
    const dados = localStorage.getItem('usuario');
    if (dados) {
      this.usuario = JSON.parse(dados);
      console.log("DEBUG PERFIL:", this.usuario); // 👈 mostra no console os campos do usuário
    }
  },
  methods: {
    formatarData(data) {
      if (!data) return '';
      return new Date(data).toLocaleDateString('pt-BR');
    },
    capitalize(texto) {
      if (!texto) return '';
      return texto.charAt(0).toUpperCase() + texto.slice(1).toLowerCase();
    },
    trocarSenha() {
      this.$router.push({ name: 'RecuperarSenha' });
    }
  }
};
</script>

<style scoped>
.perfil-card {
  max-width: 500px;
  margin: 2rem auto;
  padding: 2rem;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 6px 16px rgba(0,0,0,0.1);
  text-align: left;
  font-family: Arial, sans-serif;
}

.perfil-titulo {
  font-size: 1.8rem;
  font-weight: 600;
  color: #2d3748;
  margin-bottom: 1.5rem;
}

.perfil-info p {
  margin: 0.8rem 0;
  font-size: 1rem;
  color: #4a5568;
  padding: 0.6rem 1rem;
  background: #f9fafb;
  border-radius: 8px;
}

.perfil-info span {
  font-weight: 600;
  color: #2d3748;
  margin-right: 6px;
}

.perfil-vazio {
  text-align: center;
  color: #a0aec0;
  font-style: italic;
}

/* Botão de trocar senha */
.botao-trocar-senha {
  margin-top: 1rem;
  padding: 0.6rem 1.2rem;
  font-size: 1rem;
  font-weight: 600;
  color: #fff;
  background-color: #3182ce;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.botao-trocar-senha:hover {
  background-color: #2b6cb0;
}
</style>

<template>
  <div class="dashboard-inicial">
    <h1>Bem-vindo ao TriaTech</h1>
    <p>Olá, {{ nomeUsuario }}! Selecione uma opção no menu lateral para começar.</p>
  </div>
</template>

<script>
export default {
  name: 'MenuInicial',
  data() {
    return {
      nomeUsuario: '',
    };
  },
  mounted() {
    const usuarioSalvo = localStorage.getItem('usuario');
    if (usuarioSalvo) {
      try {
        const usuario = JSON.parse(usuarioSalvo);
        this.nomeUsuario = usuario.nome || 'Usuário';
      } catch (e) {
        console.error('Erro ao carregar usuário:', e);
        this.nomeUsuario = 'Usuário';
      }
    } else {
      this.nomeUsuario = 'Usuário';
    }
  }
};
</script>

<style scoped>
.dashboard-inicial {
  padding: 20px;
  text-align: center;
  margin-top: 50px;
}

.dashboard-inicial h1 {
  color: #2a5298;
  margin-bottom: 20px;
}

.dashboard-inicial p {
  font-size: 1.1rem;
  color: #555;
}
</style>

<template>
  <div class="container-aplicacao">
    <!-- Barra Lateral -->
    <aside class="barra-lateral">
      <div class="container-logo">
        <img src="@/assets/logo_sistema.png" alt="Logo TriaTech" class="logo" />
        <div class="nome-sistema">TriaTech</div>
      </div>
      <!-- Menu de Navegação -->
      <nav class="menu-navegacao">
        <!-- Botão Início -->
        <router-link
          to="/menu"
          custom
          v-slot="{ navigate, isActive }"
        >
          <div
            class="item-menu"
            :class="{ 'menu-ativo': isActive && $route.path === '/menu' }"
            @click="navigate"
            role="button"
            tabindex="0"
          >
            <i class="fas fa-home"></i>
            <span>Início</span>
          </div>
        </router-link>
        <!-- Triagens -->
        <router-link
          to="/menu/triagem-dados-paciente"
          custom
          v-slot="{ navigate, isActive }"
        >
          <div
            class="item-menu"
            :class="{ 'menu-ativo': isActive }"
            @click="navigate"
            role="button"
            tabindex="0"
          >
            <i class="fas fa-clipboard-list"></i>
            <span>Nova Triagem</span>
          </div>
        </router-link>
        <!-- Relatórios -->
        <router-link
          to="/menu/relatorios"
          custom
          v-slot="{ navigate, isActive }"
        >
          <div
            class="item-menu"
            :class="{ 'menu-ativo': isActive }"
            @click="navigate"
            role="button"
            tabindex="0"
          >
            <i class="fas fa-chart-line"></i>
            <span>Relatórios</span>
          </div>
        </router-link>
      </nav>
      <!-- Área do Usuário e Logout -->
      <div class="area-usuario">
        <div class="info-usuario">
          <i class="fas fa-user-circle"></i>
          <span>{{ usuario.nome || 'Usuário' }}</span>
        </div>
        <button class="botao-config" @click="abrirPerfil" tabindex="0">
          <i class="fas fa-user"></i>
          <span>Meu Perfil</span>
        </button>
        <button class="botao-logout" @click="fazerLogout" tabindex="0">
          <i class="fas fa-sign-out-alt"></i>
          <span>Sair</span>
        </button>
      </div>
      <div class="info-versao">Versão 2.1.0 • Produção</div>
    </aside>
    <!-- Conteúdo Principal -->
    <main class="conteudo-principal">
      <div class="container-conteudo">
        <router-view></router-view>
      </div>
    </main>
  </div>
</template>

<script>
export default {
  name: 'MenuPrincipal',
  data() {
    return {
      usuario: {
        nome: '',
        coren: ''
      }
    };
  },
  created() {
    this.carregarUsuario();
  },
  methods: {
    carregarUsuario() {
      const usuarioSalvo = localStorage.getItem('usuario');
      if (usuarioSalvo) {
        this.usuario = JSON.parse(usuarioSalvo);
      }
    },
    abrirPerfil() {
      this.$router.push('/menu/perfil');
    },
    fazerLogout() {
      localStorage.removeItem('token');
      localStorage.removeItem('usuario');
      this.$router.push('/login');
      console.log('Logout realizado com sucesso!');
    }
  }
};
</script>

<style scoped>
/* Variáveis locais para consistência com global.css */
:root {
  --cor-primaria: #1A5276;
  --cor-secundaria: #27AE60;
  --cor-fundo: #F5F7FA;
  --cor-fundo-cartao: #FFFFFF;
  --cor-texto: #2C3E50;
  --cor-texto-secundario: #4A5568;
  --cor-borda: #D1D5DB;
  --sombra-suave: 0 6px 20px rgba(0, 0, 0, 0.08);
  --transicao-padrao: all 0.3s ease-in-out;
  --fonte-principal: "Times New Roman", Times, serif;
}

/* Layout Principal */
.container-aplicacao {
  display: flex;
  min-height: 100vh;
  background: linear-gradient(135deg, var(--cor-fundo) 0%, #E6ECF0 100%);
}

.barra-lateral {
  width: 280px;
  padding: 20px 0;
  background: linear-gradient(to bottom, var(--cor-primaria), #2D3748);
  color: #FFFFFF;
  display: flex;
  flex-direction: column;
  box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
}

.conteudo-principal {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
}

/* Logo */
.container-logo {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 20px 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.logo {
  width: 40px;
  height: 40px;
  margin-right: 10px;
}

.nome-sistema {
  font-size: 20px;
  font-weight: 600;
  font-family: var(--fonte-principal);
}

/* Menu de Navegação */
.menu-navegacao {
  flex: 1;
  padding: 20px 0;
}

.item-menu {
  display: flex;
  align-items: center;
  padding: 12px 25px;
  margin: 5px 0;
  cursor: pointer;
  transition: var(--transicao-padrao);
  color: rgba(255, 255, 255, 0.9);
  font-size: 16px;
  font-family: var(--fonte-principal);
}

.item-menu:hover {
  background-color: rgba(255, 255, 255, 0.15);
}

.menu-ativo {
  background-color: rgba(255, 255, 255, 0.2);
  border-left: 4px solid #FFFFFF;
  font-weight: 600;
}

.item-menu i {
  width: 24px;
  margin-right: 12px;
  text-align: center;
}

/* Área do Usuário */
.area-usuario {
  padding: 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.2);
}

.info-usuario {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
  font-size: 16px;
  font-family: var(--fonte-principal);
}

.info-usuario i {
  font-size: 24px;
  margin-right: 10px;
  color: rgba(255, 255, 255, 0.8);
}

/* Botões de Configurações e Logout */
.botao-config, .botao-logout {
  display: flex;
  align-items: center;
  width: 100%;
  padding: 14px 15px;
  background-color: #2B6CB0;
  color: #FFFFFF;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: var(--transicao-padrao);
  margin-bottom: 10px;
  font-size: 16px;
  font-weight: 600;
  font-family: var(--fonte-principal);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.botao-config:hover, .botao-logout:hover {
  background-color: #2D3748;
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
}

.botao-config i, .botao-logout i {
  margin-right: 10px;
}

/* Informações de Versão */
.info-versao {
  padding: 0 20px;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
  text-align: center;
  margin-top: auto;
  font-family: var(--fonte-principal);
}

/* Container de Conteúdo */
.container-conteudo {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  background: var(--cor-fundo-cartao);
  border-radius: 8px;
  box-shadow: var(--sombra-suave);
}

/* Responsividade */
@media (max-width: 768px) {
  .barra-lateral {
    width: 240px;
  }

  .conteudo-principal {
    padding: 15px;
  }

  .container-conteudo {
    padding: 15px;
  }

  .nome-sistema {
    font-size: 18px;
  }

  .item-menu {
    font-size: 14px;
    padding: 10px 20px;
  }

  .botao-config, .botao-logout {
    padding: 12px 15px;
    font-size: 14px;
  }
}

@media (max-width: 480px) {
  .barra-lateral {
    width: 200px;
  }

  .container-logo {
    flex-direction: column;
    text-align: center;
  }

  .logo {
    margin-bottom: 10px;
  }

  .nome-sistema {
    font-size: 16px;
  }

  .item-menu {
    font-size: 13px;
    padding: 8px 15px;
  }

  .botao-config, .botao-logout {
    padding: 10px 15px;
    font-size: 13px;
  }

  .info-usuario {
    font-size: 14px;
  }
}
</style>
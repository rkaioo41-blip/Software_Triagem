<template>
  <div class="perfil-card">
    <h1 class="perfil-titulo">Meu Perfil</h1>

    <!-- Modal de confirmação de senha -->
    <div v-if="mostrarModalSenha" class="modal-senha">
      <div class="modal-conteudo">
        <div class="modal-topo">
          <h3>Confirmar Senha</h3>
          <p>Para editar seu perfil, confirme sua senha atual</p>
        </div>
        
        <form @submit.prevent="validarSenha" class="formulario-senha">
          <div class="campo-formulario">
            <label for="senhaAtual">Senha Atual:</label>
            <input
              id="senhaAtual"
              type="password"
              v-model="senhaAtual"
              class="entrada-formulario"
              placeholder="Digite sua senha atual"
              required
            />
          </div>
          
          <div v-if="mensagemErroSenha" class="mensagem-erro">
            {{ mensagemErroSenha }}
          </div>
          
          <div class="acoes-modal">
            <button type="submit" class="botao-principal" :disabled="validandoSenha">
              <span v-if="!validandoSenha">Confirmar</span>
              <span v-else class="carregando-spinner">
                <i class="fas fa-spinner fa-spin"></i> Validando...
              </span>
            </button>
            <button type="button" class="botao-secundario" @click="cancelarEdicao">
              Cancelar
            </button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="usuario" class="perfil-info">
      <!-- Modo visualização -->
      <div v-if="!modoEdicao" class="modo-visualizacao">
        <div class="info-item">
          <span class="info-rotulo">👤 Nome:</span>
          <span class="info-valor">{{ usuario.nome }}</span>
        </div>
        
        <div class="info-item">
          <span class="info-rotulo">📧 Email:</span>
          <span class="info-valor">{{ usuario.email }}</span>
        </div>
        
        <div class="info-item">
          <span class="info-rotulo">🆔 COREN:</span>
          <span class="info-valor">{{ usuario.coren }}-{{ usuario.uf }}</span>
        </div>
        
        <div class="info-item">
          <span class="info-rotulo">🏥 Instituição:</span>
          <span class="info-valor">{{ usuario.instituicao }}</span>
        </div>
        
        <div class="info-item">
          <span class="info-rotulo">🎂 Data de Nascimento:</span>
          <span class="info-valor">{{ formatarData(usuario.data_nascimento) }}</span>
        </div>
        
        <div class="info-item">
          <span class="info-rotulo">⚧ Sexo:</span>
          <span class="info-valor">{{ formatarSexo(usuario.sexo) }}</span>
        </div>

        <div class="acoes-visualizacao">
          <button class="botao-principal" @click="iniciarEdicao">
            ✏️ Editar Perfil
          </button>
          
          <button class="botao-trocar-senha" @click="trocarSenha">
            🔒 Trocar Senha
          </button>
        </div>
      </div>

      <!-- Modo edição -->
      <form v-else @submit.prevent="atualizarPerfil" class="formulario-perfil">
        <!-- Nome Completo -->
        <div class="campo-formulario">
          <label for="nome">👤 Nome:</label>
          <input 
            id="nome" 
            v-model="usuarioEditado.nome" 
            class="entrada-formulario" 
            placeholder="Seu nome completo" 
            required 
          />
        </div>
        
        <!-- E-mail -->
        <div class="campo-formulario">
          <label for="email">📧 Email:</label>
          <input 
            id="email" 
            v-model="usuarioEditado.email" 
            type="email" 
            class="entrada-formulario" 
            placeholder="seu@email.com" 
            @input="validarEmailDebounce"
            required 
          />
          <div v-if="mensagemEmail" :class="{ 
            'mensagem-sucesso': emailValido, 
            'mensagem-erro': emailValido === false 
          }">
            {{ mensagemEmail }}
          </div>
        </div>
        
        <!-- COREN e UF -->
        <div class="campo-formulario">
          <label for="coren">🆔 COREN:</label>
          <div class="campo-duplo">
            <input 
              id="coren" 
              v-model="usuarioEditado.coren" 
              class="entrada-formulario" 
              placeholder="123456-ENF"
              @input="validarCorenDebounce"
              required 
            />
            <select 
              v-model="usuarioEditado.uf" 
              class="entrada-formulario entrada-uf"
              @change="validarCorenDebounce"
              required
            >
              <option value="">Selecione</option>
              <option v-for="estado in estadosBR" :key="estado" :value="estado">{{ estado }}</option>
            </select>
          </div>
          <div v-if="mensagemCoren" :class="{ 
            'mensagem-sucesso': corenValido, 
            'mensagem-erro': corenValido === false 
          }">
            {{ mensagemCoren }}
          </div>
        </div>
        
        <!-- Instituição -->
        <div class="campo-formulario">
          <label for="instituicao">🏥 Instituição:</label>
          <input 
            id="instituicao" 
            v-model="usuarioEditado.instituicao" 
            class="entrada-formulario" 
            placeholder="Local de trabalho" 
            required 
          />
        </div>
        
        <!-- Data de Nascimento -->
        <div class="campo-formulario">
          <label for="data_nascimento">🎂 Data de Nascimento:</label>
          <input 
            id="data_nascimento" 
            v-model="usuarioEditado.data_nascimento" 
            type="date" 
            class="entrada-formulario" 
            @change="validarIdade"
            required 
          />
          <div v-if="mensagemIdade" class="mensagem-erro">
            {{ mensagemIdade }}
          </div>
        </div>
        
        <!-- Sexo -->
        <div class="campo-formulario">
          <label for="sexo">⚧ Sexo:</label>
          <select 
            id="sexo" 
            v-model="usuarioEditado.sexo" 
            class="entrada-formulario"
            required
            @change="atualizarSexo"
          >
            <option value="">Selecione</option>
            <option value="feminino">Feminino</option>
            <option value="masculino">Masculino</option>
            <option value="outro">Outro</option>
          </select>
        </div>

        <!-- Campo para especificar sexo quando for "outro" -->
        <div v-if="mostrarOutroSexo" class="campo-formulario">
          <label for="outroSexo">Especificar Sexo:</label>
          <input 
            id="outroSexo" 
            v-model="usuarioEditado.outro_sexo" 
            class="entrada-formulario" 
            placeholder="Qual?" 
          />
        </div>

        <div class="acoes-formulario">
          <button 
            type="submit" 
            class="botao-principal" 
            :disabled="carregando || !formularioValido"
          >
            <span v-if="!carregando">💾 Salvar Alterações</span>
            <span v-else class="carregando-spinner">
              <i class="fas fa-spinner fa-spin"></i> Salvando...
            </span>
          </button>
          
          <button type="button" class="botao-secundario" @click="cancelarEdicao">
            ❌ Cancelar
          </button>
        </div>

        <!-- Mensagem de erro geral -->
        <div v-if="mensagemErro" class="mensagem-erro mensagem-geral">
          <i class="fas fa-exclamation-circle"></i> {{ mensagemErro }}
        </div>
      </form>
    </div>

    <div v-else class="perfil-vazio">
      <p>Nenhuma informação encontrada. Faça login novamente.</p>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { debounce } from "lodash";
import { ofuscarSenha } from "@/utilitarios/ofuscacaoSenha";

export default {
  name: 'PerfilUsuario',
  data() {
    return {
      usuario: null,
      usuarioEditado: null,
      estadosBR: ["AC","AL","AP","AM","BA","CE","DF","ES","GO","MA","MT","MS","MG",
        "PA","PB","PR","PE","PI","RJ","RN","RS","RO","RR","SC","SP","SE","TO"],
      
      // Estados de edição
      modoEdicao: false,
      mostrarModalSenha: false,
      senhaAtual: "",
      
      // Estados de validação
      carregando: false,
      validandoSenha: false,
      mensagemErro: "",
      mensagemErroSenha: "",
      emailValido: null,
      mensagemEmail: "",
      corenValido: null,
      mensagemCoren: "",
      mensagemIdade: "",
      mostrarOutroSexo: false,
      senhaConfirmada: false
    };
  },
  computed: {
    formularioValido() {
      return this.emailValido !== false && 
             this.corenValido !== false && 
             !this.mensagemIdade &&
             this.usuarioEditado.nome && 
             this.usuarioEditado.email && 
             this.usuarioEditado.coren && 
             this.usuarioEditado.uf && 
             this.usuarioEditado.instituicao && 
             this.usuarioEditado.data_nascimento && 
             this.usuarioEditado.sexo;
    }
  },
  mounted() {
    const dados = localStorage.getItem('usuario');
    if (dados) {
      this.usuario = JSON.parse(dados);
      // Inicializar o campo outro_sexo se não existir
      if (!this.usuario.outro_sexo) {
        this.usuario.outro_sexo = "";
      }
    }
    
    // Inicializar debounce methods
    this.validarEmailDebounce = debounce(this.validarEmailCampo, 500);
    this.validarCorenDebounce = debounce(this.validarCorenCampo, 500);
  },
  methods: {
    formatarData(data) {
      if (!data) return '';
      return new Date(data).toLocaleDateString('pt-BR');
    },
    
    formatarSexo(sexo) {
      const opcoes = {
        'feminino': 'Feminino',
        'masculino': 'Masculino',
        'outro': this.usuario.outro_sexo || 'Outro'
      };
      return opcoes[sexo] || sexo;
    },
    
    iniciarEdicao() {
      this.mostrarModalSenha = true;
      this.senhaAtual = "";
      this.mensagemErroSenha = "";
    },
    
    async validarSenha() {
      this.validandoSenha = true;
      this.mensagemErroSenha = "";

      try {
        const { senhaOfuscada } = ofuscarSenha(this.senhaAtual);

        const response = await axios.post("http://localhost:3001/api/validar_senha", {
          identificador: this.usuario.email,
          password: senhaOfuscada
        });

        if (response.data.valido) {
          this.senhaConfirmada = true;
          this.mostrarModalSenha = false;
          this.entrarModoEdicao();
        } else {
          this.mensagemErroSenha = "Senha incorreta. Tente novamente.";
        }
      } catch (error) {
        console.error("Erro ao validar senha:", error);
        this.mensagemErroSenha = "Erro ao validar senha. Tente novamente.";
      } finally {
        this.validandoSenha = false;
      }
    },
    
    entrarModoEdicao() {
      // Criar cópia do usuário para edição
      this.usuarioEditado = JSON.parse(JSON.stringify(this.usuario));
      this.modoEdicao = true;
      this.atualizarSexo();
    },
    
    cancelarEdicao() {
      this.mostrarModalSenha = false;
      this.modoEdicao = false;
      this.senhaConfirmada = false;
      this.senhaAtual = "";
      this.mensagemErroSenha = "";
      this.mensagemErro = "";
    },
    
    atualizarSexo() {
      this.mostrarOutroSexo = this.usuarioEditado.sexo === "outro";
      if (!this.mostrarOutroSexo) {
        this.usuarioEditado.outro_sexo = "";
      }
    },
    
    validarIdade() {
      if (!this.usuarioEditado.data_nascimento) {
        this.mensagemIdade = "";
        return;
      }

      const hoje = new Date();
      const nascimento = new Date(this.usuarioEditado.data_nascimento);
      let idade = hoje.getFullYear() - nascimento.getFullYear();
      const mes = hoje.getMonth() - nascimento.getMonth();
      
      if (mes < 0 || (mes === 0 && hoje.getDate() < nascimento.getDate())) {
        idade--;
      }

      if (idade < 18) {
        this.mensagemIdade = "❌ Idade mínima para cadastro: 18 anos.";
      } else {
        this.mensagemIdade = "";
      }
    },

    async validarEmailCampo() {
      if (!this.usuarioEditado.email) {
        this.mensagemEmail = "";
        this.emailValido = null;
        return;
      }
      
      // Verificar se o email foi alterado
      if (this.usuarioEditado.email === this.usuario.email) {
        this.emailValido = true;
        this.mensagemEmail = "✅ E-mail atual (válido)";
        return;
      }
      
      try {
        const { data } = await axios.post("http://localhost:3001/api/enfermeiros/validar_email", { 
          email: this.usuarioEditado.email 
        });
        
        this.emailValido = data.valido;
        this.mensagemEmail = data.mensagem || (this.emailValido ? "✅ E-mail disponível!" : "❌ E-mail já cadastrado!");
      } catch {
        this.emailValido = false;
        this.mensagemEmail = "⚠️ Erro ao validar e-mail.";
      }
    },

    async validarCorenCampo() {
      if (!this.usuarioEditado.coren || !this.usuarioEditado.uf) {
        this.mensagemCoren = this.usuarioEditado.uf ? "" : "❌ Selecione a UF";
        this.corenValido = null;
        return;
      }
      
      // Verificar se o COREN foi alterado
      if (this.usuarioEditado.coren === this.usuario.coren && 
          this.usuarioEditado.uf === this.usuario.uf) {
        this.corenValido = true;
        this.mensagemCoren = "✅ COREN atual (válido)";
        return;
      }
      
      try {
        const { data } = await axios.post("http://localhost:3001/api/validar_coren", {
          coren: this.usuarioEditado.coren,
          uf: this.usuarioEditado.uf
        });
        
        this.corenValido = data.valido;
        this.mensagemCoren = data.mensagem || (this.corenValido ? "✅ COREN válido!" : "❌ COREN inválido!");
      } catch {
        this.corenValido = false;
        this.mensagemCoren = "⚠️ Erro ao validar COREN.";
      }
    },

    async atualizarPerfil() {
      // Validações finais antes de enviar
      if (!this.emailValido) {
        this.mensagemErro = "E-mail inválido ou já cadastrado.";
        return;
      }
      
      if (!this.corenValido) {
        this.mensagemErro = "COREN inválido ou já cadastrado.";
        return;
      }
      
      if (this.mensagemIdade) {
        this.mensagemErro = "Idade mínima para cadastro: 18 anos.";
        return;
      }

      this.carregando = true;
      this.mensagemErro = "";

      try {
        // Preparar dados para envio
        const dadosAtualizacao = {
          nome: this.usuarioEditado.nome,
          email: this.usuarioEditado.email,
          coren: this.usuarioEditado.coren,
          uf: this.usuarioEditado.uf,
          instituicao: this.usuarioEditado.instituicao,
          data_nascimento: this.usuarioEditado.data_nascimento,
          sexo: this.usuarioEditado.sexo === "outro" ? this.usuarioEditado.outro_sexo : this.usuarioEditado.sexo
        };

        const { data } = await axios.put(
          `http://localhost:3001/api/enfermeiros/${this.usuario.id}`, 
          { enfermeiro: dadosAtualizacao }
        );

        // Atualizar localStorage com os novos dados
        const usuarioAtualizado = { ...this.usuario, ...dadosAtualizacao };
        this.usuario = usuarioAtualizado;
        localStorage.setItem('usuario', JSON.stringify(usuarioAtualizado));
        
        // Sair do modo edição
        this.modoEdicao = false;
        this.senhaConfirmada = false;
        
        alert(data.mensagem || "Perfil atualizado com sucesso!");
      } catch (erro) {
        console.error(erro);
        this.mensagemErro = erro.response?.data?.erro || "Erro ao atualizar perfil. Tente novamente.";
      } finally {
        this.carregando = false;
      }
    },
    
    trocarSenha() {
      this.$router.push({ name: 'RecuperarSenha' });
    }
  }
};
</script>

<style scoped>
.perfil-card {
  max-width: 600px;
  margin: 2rem auto;
  padding: 2.5rem;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  color: #333;
}

.perfil-titulo {
  font-size: 2rem;
  font-weight: 700;
  color: #2c3e50;
  margin-bottom: 2rem;
  text-align: center;
  border-bottom: 2px solid #f0f2f5;
  padding-bottom: 1rem;
}

/* Modal de senha */
.modal-senha {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-conteudo {
  background: white;
  padding: 2rem;
  border-radius: 12px;
  width: 90%;
  max-width: 400px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
}

.modal-topo {
  text-align: center;
  margin-bottom: 1.5rem;
}

.modal-topo h3 {
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.modal-topo p {
  color: #666;
  font-size: 0.9rem;
}

.formulario-senha {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.acoes-modal {
  display: flex;
  gap: 1rem;
  margin-top: 1rem;
}

.acoes-modal button {
  flex: 1;
}

/* Modo visualização */
.modo-visualizacao {
  display: flex;
  flex-direction: column;
  gap: 1.2rem;
}

.info-item {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 1rem;
  background: #f8fafc;
  border-radius: 8px;
  border-left: 4px solid #4299e1;
}

.info-rotulo {
  font-weight: 600;
  color: #2d3748;
  min-width: 150px;
}

.info-valor {
  color: #4a5568;
  text-align: right;
  flex: 1;
}

.acoes-visualizacao {
  display: flex;
  gap: 1rem;
  margin-top: 2rem;
}

.acoes-visualizacao button {
  flex: 1;
}

/* Modo edição */
.formulario-perfil {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.campo-formulario {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.campo-formulario label {
  font-weight: 600;
  color: #2d3748;
  font-size: 1rem;
}

.entrada-formulario {
  padding: 0.75rem 1rem;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  font-size: 1rem;
  transition: all 0.2s ease;
  background-color: #f9fafb;
}

.entrada-formulario:focus {
  outline: none;
  border-color: #4299e1;
  box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.15);
  background-color: #fff;
}

.campo-duplo {
  display: flex;
  gap: 0.75rem;
}

.campo-duplo .entrada-formulario {
  flex: 1;
}

.entrada-uf {
  max-width: 80px;
}

.acoes-formulario {
  display: flex;
  gap: 1rem;
  margin-top: 1.5rem;
}

/* Botões */
.botao-principal {
  padding: 0.85rem 1.5rem;
  font-size: 1rem;
  font-weight: 600;
  color: #fff;
  background: linear-gradient(135deg, #4299e1, #3182ce);
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 6px rgba(66, 153, 225, 0.2);
}

.botao-principal:hover:not(:disabled) {
  background: linear-gradient(135deg, #3182ce, #2b6cb0);
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(66, 153, 225, 0.3);
}

.botao-principal:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
}

.botao-secundario {
  padding: 0.75rem 1.5rem;
  font-size: 1rem;
  font-weight: 600;
  color: #718096;
  background-color: transparent;
  border: 2px solid #e2e8f0;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.botao-secundario:hover {
  background-color: #f7fafc;
  border-color: #cbd5e0;
}

.botao-trocar-senha {
  padding: 0.75rem 1.5rem;
  font-size: 1rem;
  font-weight: 600;
  color: #4299e1;
  background-color: transparent;
  border: 2px solid #4299e1;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.botao-trocar-senha:hover {
  background-color: #4299e1;
  color: #fff;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(66, 153, 225, 0.2);
}

/* Mensagens de validação */
.mensagem-sucesso {
  color: #38a169;
  font-size: 0.875rem;
  margin-top: 0.25rem;
  font-weight: 500;
}

.mensagem-erro {
  color: #e53e3e;
  font-size: 0.875rem;
  margin-top: 0.25rem;
  font-weight: 500;
}

.mensagem-geral {
  background-color: #fed7d7;
  padding: 0.75rem;
  border-radius: 8px;
  border-left: 4px solid #e53e3e;
}

.carregando-spinner {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.perfil-vazio {
  text-align: center;
  color: #a0aec0;
  font-style: italic;
  padding: 2rem;
}

/* Responsividade */
@media (max-width: 640px) {
  .perfil-card {
    margin: 1rem;
    padding: 1.5rem;
  }
  
  .info-item {
    flex-direction: column;
    gap: 0.5rem;
  }
  
  .info-rotulo, .info-valor {
    text-align: left;
    min-width: auto;
  }
  
  .campo-duplo {
    flex-direction: column;
  }
  
  .entrada-uf {
    max-width: 100%;
  }
  
  .acoes-visualizacao,
  .acoes-formulario,
  .acoes-modal {
    flex-direction: column;
  }
  
  .modal-conteudo {
    margin: 1rem;
    width: calc(100% - 2rem);
  }
}
</style>
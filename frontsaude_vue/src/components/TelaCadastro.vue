<template>
  <div class="container-cadastro-unificado">
    <div class="cartao-cadastro">
      <div class="cabecalho-cadastro">
        <div class="logo-container">
          <img src="@/assets/logo_sistema.png" alt="Logo Sistema" class="logo-sistema" />
        </div>
        <h1 class="titulo-cadastro">Sistema de Triagem</h1>
        <p class="subtitulo-cadastro">Cadastro de Enfermeiro</p>
      </div>

      <form @submit.prevent="cadastrar" class="formulario-cadastro">
        <!-- Nome Completo -->
        <div class="grupo-formulario">
          <label class="rotulo-formulario">Nome Completo</label>
          <input type="text" v-model="nome" class="entrada-formulario" placeholder="Seu nome completo" required />
        </div>

        <!-- Data Nascimento e CPF -->
        <div class="grupo-duplo">
          <div class="grupo-formulario">
            <label class="rotulo-formulario">Data Nascimento</label>
            <input
              type="date"
              v-model="dataNascimento"
              class="entrada-formulario"
              @change="validarIdade"
              required
            />
            <div v-if="mensagemIdade" class="mensagem-erro">{{ mensagemIdade }}</div>
          </div>
          <div class="grupo-formulario">
            <label class="rotulo-formulario" for="cpf">CPF</label>
            <input
              id="cpf"
              type="text"
              v-model="cpf"
              v-mask="'###.###.###-##'"
              @input="validarCpfDebounce"
              class="entrada-formulario"
              placeholder="000.000.000-00"
              required
            />
            <div v-if="mensagemCpf" :class="{ 'mensagem-sucesso': cpfValido, 'mensagem-erro': cpfValido === false }">
              {{ mensagemCpf }}
            </div>
          </div>
        </div>

        <!-- Sexo -->
        <div class="grupo-duplo">
          <div class="grupo-formulario">
            <label class="rotulo-formulario">Sexo</label>
            <select v-model="sexo" class="entrada-formulario" required @change="atualizarSexo">
              <option value="">Selecione</option>
              <option value="feminino">Feminino</option>
              <option value="masculino">Masculino</option>
              <option value="outro">Outro</option>
            </select>
          </div>
          <div class="grupo-formulario" v-if="mostrarOutroSexo">
            <label class="rotulo-formulario">Especificar</label>
            <input type="text" v-model="outroSexo" class="entrada-formulario" placeholder="Qual?" />
          </div>
        </div>

        <!-- E-mail -->
        <div class="grupo-formulario">
          <label class="rotulo-formulario">E-mail</label>
          <input type="email" v-model="email" @input="validarEmailDebounce" class="entrada-formulario" placeholder="seu@email.com" required />
          <div v-if="mensagemEmail" :class="{ 'mensagem-sucesso': emailValido, 'mensagem-erro': emailValido === false }">
            {{ mensagemEmail }}
          </div>
        </div>

        <!-- COREN e UF -->
        <div class="grupo-duplo">
          <div class="grupo-formulario">
            <label class="rotulo-formulario">COREN</label>
            <input
              type="text"
              v-model="coren"
              @input="validarCorenDebounce"
              class="entrada-formulario"
              placeholder="123456-ENF"
              required
            />
            <div v-if="mensagemCoren" :class="{ 'mensagem-sucesso': corenValido, 'mensagem-erro': corenValido === false }">
              {{ mensagemCoren }}
            </div>
          </div>
          <div class="grupo-formulario">
            <label class="rotulo-formulario">UF</label>
            <select v-model="uf" class="entrada-formulario" required @change="validarCorenDebounce">
              <option value="">Selecione</option>
              <option v-for="estado in estadosBR" :key="estado" :value="estado">{{ estado }}</option>
            </select>
          </div>
        </div>

        <!-- Instituição -->
        <div class="grupo-formulario">
          <label class="rotulo-formulario">Instituição</label>
          <input type="text" v-model="instituicao" class="entrada-formulario" placeholder="Local de trabalho" required />
        </div>

        <!-- Senha -->
        <div class="grupo-duplo">
          <div class="grupo-formulario">
            <label class="rotulo-formulario">Senha</label>
            <input type="password" v-model="senha" class="entrada-formulario" placeholder="••••••••" required />
          </div>
          <div class="grupo-formulario">
            <label class="rotulo-formulario">Confirmar Senha</label>
            <input type="password" v-model="confirmarSenha" class="entrada-formulario" placeholder="••••••••" required />
          </div>
        </div>

        <!-- Termos -->
        <div class="grupo-termos">
          <label class="checkbox-termos">
            <input type="checkbox" v-model="aceitouTermos" required />
            <span class="checkmark"></span>
            Aceito os <a href="#" @click.prevent="abrirModal('termos')">Termos</a> e
            <a href="#" @click.prevent="abrirModal('privacidade')">Política de Privacidade</a>
          </label>
        </div>

        <!-- Mensagem de erro -->
        <div v-if="mensagemErro" class="mensagem-erro">
          <i class="fas fa-exclamation-circle"></i> {{ mensagemErro }}
        </div>

        <!-- Botão Cadastrar -->
        <button type="submit" class="botao-principal" :disabled="carregando">
          <span v-if="!carregando">Cadastrar</span>
          <span v-else class="carregando-spinner"><i class="fas fa-spinner fa-spin"></i> Processando...</span>
        </button>
      </form>

      <!-- Rodapé -->
      <div class="rodape-cadastro">
        <p>
          Já tem uma conta?
          <router-link to="/login" class="link-login">Faça login</router-link>
        </p>
      </div>
    </div>

    <!-- Modais -->
    <div v-if="modalTermos || modalPrivacidade" class="modal" @click.self="fecharModal">
      <div class="modal-conteudo">
        <div class="modal-topo">
          <h3>{{ modalTermos ? "Termos de Uso" : "Política de Privacidade" }}</h3>
          <button @click="fecharModal" class="modal-fechar">×</button>
        </div>
        <div class="modal-corpo">
          <component :is="modalTermos ? 'TermosUso' : 'PoliticaPrivacidade'" />
        </div>
        <div class="modal-rodape">
          <button @click="fecharModal" class="botao-secundario">Fechar</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { ofuscarSenha } from "@/utilitarios/ofuscacaoSenha";
import TermosUso from "./ProteçãoDados/TermosUso.vue";
import PoliticaPrivacidade from "./ProteçãoDados/PoliticaPrivacidade.vue";
import { mask } from "vue-the-mask";
import { debounce } from "lodash";

export default {
  directives: { mask },
  components: { TermosUso, PoliticaPrivacidade },
  data() {
    return {
      nome: "",
      dataNascimento: "",
      mensagemIdade: "",
      sexo: "",
      cpf: "",
      cpfValido: null,
      mensagemCpf: "",
      outroSexo: "",
      mostrarOutroSexo: false,
      email: "",
      emailValido: null,
      mensagemEmail: "",
      coren: "",
      uf: "",
      corenValido: null,
      mensagemCoren: "",
      instituicao: "",
      senha: "",
      confirmarSenha: "",
      aceitouTermos: false,
      carregando: false,
      mensagemErro: "",
      modalTermos: false,
      modalPrivacidade: false,
      estadosBR: [
        "AC","AL","AP","AM","BA","CE","DF","ES","GO","MA","MT","MS","MG",
        "PA","PB","PR","PE","PI","RJ","RN","RS","RO","RR","SC","SP","SE","TO"
      ]
    };
  },
  created() {
    this.validarCpfDebounce = debounce(this.validarCpfCampo, 500);
    this.validarEmailDebounce = debounce(this.validarEmailCampo, 500);
    this.validarCorenDebounce = debounce(this.validarCorenCampo, 500);
  },
  methods: {
    atualizarSexo() {
      this.mostrarOutroSexo = this.sexo === "outro";
      if (!this.mostrarOutroSexo) this.outroSexo = "";
    },
    validarIdade() {
      if (!this.dataNascimento) {
        this.mensagemIdade = "";
        return;
      }

      const hoje = new Date();
      const nascimento = new Date(this.dataNascimento);
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

    async validarCpfCampo() {
      if (!this.cpf) {
        this.mensagemCpf = "";
        this.cpfValido = null;
        return;
      }
      try {
        const { data } = await axios.post("http://localhost:3001/api/enfermeiros/validar_cpf", { cpf: this.cpf });
        this.cpfValido = data.valido;
        this.mensagemCpf = data.mensagem || (this.cpfValido ? "✅ CPF válido!" : "❌ CPF inválido!");
      } catch {
        this.cpfValido = false;
        this.mensagemCpf = "⚠️ Erro ao validar CPF.";
      }
    },

    async validarEmailCampo() {
      if (!this.email) {
        this.mensagemEmail = "";
        this.emailValido = null;
        return;
      }
      try {
        const { data } = await axios.post("http://localhost:3001/api/enfermeiros/validar_email", { email: this.email });
        this.emailValido = data.valido;
        this.mensagemEmail = data.mensagem || (this.emailValido ? "✅ E-mail disponível!" : "❌ E-mail já cadastrado!");
      } catch {
        this.emailValido = false;
        this.mensagemEmail = "⚠️ Erro ao validar e-mail.";
      }
    },

    async validarCorenCampo() {
      if (!this.coren || !this.uf) {
        this.mensagemCoren = this.uf ? "" : "❌ Selecione a UF";
        this.corenValido = null;
        return;
      }
      try {
        const { data } = await axios.post("http://localhost:3001/api/validar_coren", {
          coren: this.coren,
          uf: this.uf
        });
        this.corenValido = data.valido;
        this.mensagemCoren = data.mensagem || (this.corenValido ? "✅ COREN válido!" : "❌ COREN inválido!");
      } catch {
        this.corenValido = false;
        this.mensagemCoren = "⚠️ Erro ao validar COREN.";
      }
    },

    async cadastrar() {
      if (this.senha !== this.confirmarSenha) {
        this.mensagemErro = "As senhas não coincidem!";
        return;
      }
      if (!this.cpfValido) {
        this.mensagemErro = "CPF inválido! Verifique e tente novamente.";
        return;
      }
      if (!this.emailValido) {
        this.mensagemErro = "E-mail inválido ou já cadastrado.";
        return;
      }
      if (!this.corenValido) {
        this.mensagemErro = "COREN inválido ou já cadastrado.";
        return;
      }

      this.carregando = true;
      this.mensagemErro = "";

      try {
        const { senhaOfuscada } = ofuscarSenha(this.senha);

        await axios.post("http://localhost:3001/api/enfermeiros", {
          enfermeiro: {
            nome: this.nome,
            data_nascimento: this.dataNascimento,
            cpf: this.cpf.replace(/\D/g, ""),
            sexo: this.sexo === "outro" ? this.outroSexo : this.sexo,
            email: this.email,
            coren: this.coren,
            uf: this.uf,
            instituicao: this.instituicao,
            password: senhaOfuscada
          }
        });

        alert("Cadastro realizado com sucesso!");
        this.$router.push("/login");
      } catch (erro) {
        console.error(erro);
        this.mensagemErro = erro.response?.data?.erro || "Erro ao realizar cadastro. Tente novamente.";
      } finally {
        this.carregando = false;
      }
    },

    abrirModal(tipo) {
      this.modalTermos = tipo === "termos";
      this.modalPrivacidade = tipo === "privacidade";
    },

    fecharModal() {
      this.modalTermos = false;
      this.modalPrivacidade = false;
    }
  }
};
</script>



<style scoped>
/* Variáveis de cores (mantidas iguais ao login) */
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
.container-cadastro-unificado {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: var(--cor-fundo);
  padding: 20px;
}

.cartao-cadastro {
  width: 100%;
  max-width: 540px;
  background: white;
  border-radius: 12px;
  box-shadow: var(--sombra-suave);
  padding: 40px;
  animation: fadeIn 0.5s ease;
}

/* Cabeçalho */
.cabecalho-cadastro {
  text-align: center;
  margin-bottom: 30px;
}
.input-com-botao {
  display: flex;
  gap: 8px;
}

.botao-validar {
  padding: 8px 12px;
  background-color: var(--cor-secundaria);
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
  transition: var(--transicao-padrao);
}

.botao-validar:hover:not(:disabled) {
  background-color: #219653;
}

.mensagem-sucesso {
  color: #27AE60;
  font-size: 0.85rem;
  margin-top: 4px;
}

.mensagem-erro {
  color: var(--cor-erro);
  font-size: 0.85rem;
  margin-top: 4px;
}

.logo-container {
  text-align: center;
  margin-bottom: 20px;
}

.logo-sistema {
  max-width: 90px;
  height: auto;
}

.titulo-cadastro {
  font-size: 1.8rem;
  font-weight: 600;
  color: var(--cor-texto);
  margin-bottom: 8px;
}

.subtitulo-cadastro {
  font-size: 0.95rem;
  color: var(--cor-texto-secundario);
  margin: 0;
}

/* Formulário */
.formulario-cadastro {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.grupo-duplo {
  display: flex;
  gap: 15px;
}

.grupo-formulario {
  flex: 1;
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

select.entrada-formulario {
  appearance: none;
  background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right 10px center;
  background-size: 1em;
}

/* Termos */
.grupo-termos {
  margin: 10px 0;
}

.checkbox-termos {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 0.9rem;
  color: var(--cor-texto-secundario);
  cursor: pointer;
}

.checkbox-termos input {
  display: none;
}

.checkbox-termos .checkmark {
  width: 18px;
  height: 18px;
  border: 2px solid var(--cor-borda);
  border-radius: 4px;
  display: inline-block;
  position: relative;
  transition: var(--transicao-padrao);
}

.checkbox-termos input:checked + .checkmark {
  background-color: var(--cor-primaria);
  border-color: var(--cor-primaria);
}

.checkbox-termos input:checked + .checkmark::after {
  content: "";
  position: absolute;
  left: 5px;
  top: 2px;
  width: 4px;
  height: 8px;
  border: solid white;
  border-width: 0 2px 2px 0;
  transform: rotate(45deg);
}

.checkbox-termos a {
  color: var(--cor-primaria);
  text-decoration: none;
  font-weight: 500;
}

.checkbox-termos a:hover {
  color: var(--cor-secundaria);
  text-decoration: underline;
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

/* Botões */
.botao-principal {
  padding: 14px;
  background: linear-gradient(135deg, var(--cor-primaria) 0%, #256E8F 100%);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: var(--transicao-padrao);
  margin-top: 10px;
  box-shadow: 0 2px 4px rgba(46, 134, 171, 0.2);
}

.botao-principal:hover:not(:disabled) {
  background: linear-gradient(135deg, #256E8F 0%, #1E5A75 100%);
  box-shadow: 0 4px 8px rgba(46, 134, 171, 0.3);
  transform: translateY(-1px);
}

.botao-principal:active:not(:disabled) {
  transform: translateY(0);
}

.botao-principal:disabled {
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
.rodape-cadastro {
  text-align: center;
  margin-top: 25px;
  padding-top: 20px;
  border-top: 1px solid var(--cor-borda);
  font-size: 0.9rem;
  color: var(--cor-texto-secundario);
}

.link-login {
  color: var(--cor-secundaria);
  text-decoration: none;
  font-weight: 600;
  transition: var(--transicao-padrao);
}

.link-login:hover {
  color: #219653;
  text-decoration: underline;
}

/* Modal */
.modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  padding: 20px;
}

.modal-conteudo {
  background: white;
  border-radius: 12px;
  width: 100%;
  max-width: 700px;
  max-height: 80vh;
  overflow-y: auto;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
}

.modal-topo {
  padding: 20px;
  border-bottom: 1px solid var(--cor-borda);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-topo h3 {
  margin: 0;
  font-size: 1.3rem;
  color: var(--cor-texto);
}

.modal-fechar {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  color: var(--cor-texto-secundario);
  transition: var(--transicao-padrao);
}

.modal-fechar:hover {
  color: var(--cor-texto);
}

.modal-corpo {
  padding: 20px;
}

.modal-rodape {
  padding: 20px;
  border-top: 1px solid var(--cor-borda);
  text-align: right;
}

.botao-secundario {
  padding: 10px 20px;
  background-color: var(--cor-secundaria);
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: 500;
  cursor: pointer;
  transition: var(--transicao-padrao);
}

.botao-secundario:hover {
  background-color: #219653;
}

/* Animações */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(15px); }
  to { opacity: 1; transform: translateY(0); }
}

/* Responsividade */
@media (max-width: 768px) {
  .cartao-cadastro {
    padding: 30px 25px;
    max-width: 100%;
  }
  
  .grupo-duplo {
    flex-direction: column;
    gap: 20px;
  }
  
  .titulo-cadastro {
    font-size: 1.6rem;
  }
  
  .subtitulo-cadastro {
    font-size: 0.9rem;
  }
  
  .modal-conteudo {
    width: 95%;
    max-height: 85vh;
  }
  
  .modal-topo,
  .modal-corpo,
  .modal-rodape {
    padding: 15px;
  }
}
</style>
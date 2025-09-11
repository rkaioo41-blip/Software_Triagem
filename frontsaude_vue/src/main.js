import { createApp } from 'vue'
import App from './App.vue'
import { createPinia } from 'pinia'
import router from './router'
import Toast, { POSITION } from 'vue-toastification'
import '@fortawesome/fontawesome-free/css/all.css'
import 'vue-toastification/dist/index.css'
import '@/assets/css/global.css'


const app = createApp(App)

// Configuração completa do Toast
const toastOptions = {
  position: POSITION.TOP_RIGHT,
  timeout: 3000,
  closeOnClick: true,
  pauseOnFocusLoss: true,
  pauseOnHover: true,
  draggable: true,
  draggablePercent: 0.6,
  showCloseButtonOnHover: false,
  hideProgressBar: false,
  icon: true
}



app.use(createPinia())
app.use(router)
app.use(Toast, toastOptions) // Registra o plugin globalmente

app.mount('#app')
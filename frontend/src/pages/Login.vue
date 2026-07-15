<template>
  <div class="auth-wrapper">
    <div class="auth-card">
      <h2>Iniciar Sesión</h2>
      <form @submit.prevent="submitLogin">
        <div class="form-group">
          <label>Usuario</label>
          <input v-model="form.username" type="text" required />
        </div>
        <div class="form-group">
          <label>Contraseña</label>
          <input v-model="form.password" type="password" required />
        </div>

        <button type="submit" class="btn-submit" :disabled="isLoading">
          {{ isLoading ? 'Ingresando...' : 'Entrar' }}
        </button>
      </form>

      <p v-if="errorMessage" class="error-msg">{{ errorMessage }}</p>

      <div class="auth-footer">
        ¿No tienes cuenta? <router-link to="/register">Regístrate aquí</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import userApi from '@/api/user.js'

const router = useRouter()
const form = reactive({ username: '', password: '' })
const isLoading = ref(false)
const errorMessage = ref('')

const submitLogin = async () => {
  isLoading.value = true
  errorMessage.value = ''

  try {
    const data = await userApi.login(form)
    if (data && data.token) {
      localStorage.setItem('loa_token', data.token)
      localStorage.setItem(
        'loa_user',
        JSON.stringify({
          username: data.username,
          role: data.role,
        }),
      )
    }

    router.push('/tasks')
  } catch (error) {
    if (error.response?.status === 401 || error.response?.status === 403) {
      errorMessage.value = 'Credenciales inválidas.'
    } else {
      errorMessage.value = 'Error al conectar con el servidor.'
    }
  } finally {
    isLoading.value = false
  }
}
</script>

<style scoped>
.auth-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 70vh;
}
.auth-card {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 400px;
}
.auth-card h2 {
  text-align: center;
  margin-top: 0;
  color: #2c3e50;
}
.form-group {
  margin-bottom: 15px;
}
.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: 500;
}
.form-group input {
  width: 100%;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}
.btn-submit {
  width: 100%;
  padding: 10px;
  background-color: #3498db;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 1em;
  cursor: pointer;
  margin-top: 10px;
}
.btn-submit:disabled {
  background-color: #95a5a6;
}
.error-msg {
  color: #e74c3c;
  margin-top: 15px;
  text-align: center;
  font-size: 0.9em;
}
.auth-footer {
  margin-top: 20px;
  text-align: center;
  font-size: 0.9em;
}
</style>

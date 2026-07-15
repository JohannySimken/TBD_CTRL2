<template>
  <div id="app-container">
    <nav v-if="isAuthenticated" class="navbar">
      <div class="nav-brand">
        <strong>Task Management</strong>
      </div>
      <div class="nav-links">
        <router-link to="/tasks">Mis Tareas</router-link>
        <router-link to="/sectors">Sectores</router-link>
        <router-link to="/stats">Estadísticas</router-link>
      </div>
      <div class="nav-user">
        <span v-if="username" class="user-greeting">Hola, {{ username }}</span>
        <button @click="handleLogout" class="btn-logout">Cerrar Sesión</button>
      </div>
    </nav>

    <main class="main-content">
      <router-view />
    </main>
  </div>
</template>

<script setup>
import { ref, computed, watchEffect } from 'vue'
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()

const isAuthenticated = ref(false)
const username = ref('')

watchEffect(() => {
  // Dependencia en route.path para re-ejecutar en cada navegación
  void route.path

  const token = localStorage.getItem('loa_token')
  const userStr = localStorage.getItem('loa_user')

  isAuthenticated.value = !!token

  if (userStr) {
    try {
      const user = JSON.parse(userStr)
      username.value = user.username
    } catch (e) {
      console.error('Error parseando usuario del localStorage', e)
    }
  } else {
    username.value = ''
  }
})

const handleLogout = () => {
  localStorage.removeItem('loa_token')
  localStorage.removeItem('loa_user')
  isAuthenticated.value = false
  router.push('/login')
}
</script>

<style>
/* Estilos globales básicos */
body {
  margin: 0;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: #f4f7f6;
}
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #2c3e50;
  color: white;
  padding: 1rem 2rem;
}
.nav-links {
  display: flex;
  gap: 20px;
}
.nav-links a {
  color: #ecf0f1;
  text-decoration: none;
  font-weight: 500;
}
.nav-links a.router-link-active {
  color: #3498db;
  border-bottom: 2px solid #3498db;
}
.nav-user {
  display: flex;
  gap: 15px;
  align-items: center;
}
.user-greeting {
  font-size: 0.9em;
  opacity: 0.8;
}
.btn-logout {
  background: transparent;
  border: 1px solid #e74c3c;
  color: #e74c3c;
  padding: 5px 10px;
  border-radius: 4px;
  cursor: pointer;
  transition: 0.3s;
}
.btn-logout:hover {
  background: #e74c3c;
  color: white;
}
.main-content {
  padding: 2rem;
  max-width: 1200px;
  margin: 0 auto;
}
</style>

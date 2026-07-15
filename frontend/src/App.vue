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
        <div class="notif-wrapper" ref="notifWrapperRef">
          <button class="btn-bell" @click="toggleDropdown" aria-label="Notificaciones">
            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M18 8a6 6 0 0 0-12 0c0 7-3 9-3 9h18s-3-2-3-9" />
              <path d="M13.73 21a2 2 0 0 1-3.46 0" />
            </svg>
            <span v-if="upcomingTasks.length > 0" class="bell-badge">{{ upcomingTasks.length }}</span>
          </button>
          <div v-if="showDropdown" class="notif-dropdown">
            <div class="notif-header">Tareas por vencer</div>
            <div v-if="upcomingTasks.length === 0" class="notif-empty">Sin tareas próximas a vencer.</div>
            <ul v-else class="notif-list">
              <li v-for="t in upcomingTasks" :key="t.id" class="notif-item">
                <span class="notif-title">{{ t.title }}</span>
                <span class="notif-due">Vence: {{ formatDueDate(t.dueDate) }}</span>
              </li>
            </ul>
          </div>
        </div>
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
import { ref, computed, watchEffect, onMounted, onUnmounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import taskApi from '@/api/task.js'

const router = useRouter()
const route = useRoute()

const isAuthenticated = ref(false)
const username = ref('')

const showDropdown = ref(false)
const notifWrapperRef = ref(null)
const pendingTasks = ref([])
const WEEK_MS = 7 * 24 * 60 * 60 * 1000

const upcomingTasks = computed(() => {
  const now = Date.now()
  return pendingTasks.value
    .filter((t) => {
      const dueTime = new Date(t.dueDate).getTime() - now
      return dueTime >= 0 && dueTime <= WEEK_MS
    })
    .sort((a, b) => new Date(a.dueDate) - new Date(b.dueDate))
})

const formatDueDate = (dueDate) => {
  const date = new Date(dueDate)
  if (Number.isNaN(date.getTime())) return dueDate
  return date.toLocaleString('es-CL', { dateStyle: 'medium', timeStyle: 'short' })
}

const toggleDropdown = () => {
  showDropdown.value = !showDropdown.value
}

const handleClickOutside = (event) => {
  if (notifWrapperRef.value && !notifWrapperRef.value.contains(event.target)) {
    showDropdown.value = false
  }
}

const fetchPendingTasks = async () => {
  if (!isAuthenticated.value) {
    pendingTasks.value = []
    return
  }
  try {
    pendingTasks.value = await taskApi.getTasks({ status: 'PENDING' })
  } catch (e) {
    pendingTasks.value = []
  }
}

let pollTimer = null

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

  fetchPendingTasks()
})

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
  pollTimer = setInterval(fetchPendingTasks, 5 * 60 * 1000)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
  if (pollTimer) clearInterval(pollTimer)
})

const handleLogout = () => {
  localStorage.removeItem('loa_token')
  localStorage.removeItem('loa_user')
  isAuthenticated.value = false
  pendingTasks.value = []
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
.notif-wrapper {
  position: relative;
}
.btn-bell {
  position: relative;
  background: transparent;
  border: none;
  color: #ecf0f1;
  cursor: pointer;
  padding: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: background 0.2s;
}
.btn-bell:hover {
  background: rgba(255, 255, 255, 0.1);
}
.bell-badge {
  position: absolute;
  top: 0;
  right: 0;
  background: #e74c3c;
  color: white;
  font-size: 0.7em;
  font-weight: 700;
  min-width: 16px;
  height: 16px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 3px;
}
.notif-dropdown {
  position: absolute;
  top: calc(100% + 10px);
  right: 0;
  width: 300px;
  max-height: 360px;
  overflow-y: auto;
  background: white;
  color: #2c3e50;
  border-radius: 8px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.25);
  z-index: 1100;
}
.notif-header {
  padding: 10px 16px;
  font-weight: 700;
  font-size: 0.72em;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: #6c757d;
  background: #f4f6f8;
  border-bottom: 1px solid #e3e6e9;
  border-radius: 8px 8px 0 0;
}
.notif-empty {
  padding: 16px;
  color: #999;
  font-style: italic;
  font-size: 0.85em;
}
.notif-list {
  list-style: none;
  margin: 0;
  padding: 0;
}
.notif-item {
  padding: 10px 16px;
  border-bottom: 1px solid #f0f0f0;
  display: flex;
  flex-direction: column;
  gap: 3px;
}
.notif-item:last-child {
  border-bottom: none;
}
.notif-title {
  font-weight: 600;
  font-size: 0.9em;
}
.notif-due {
  font-size: 0.8em;
  color: #856404;
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

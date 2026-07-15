<template>
  <div>
    <h2>Gestión de Tareas</h2>

    <div v-if="urgentTasks.length > 0" style="border: 1px solid red; padding: 10px">
      <strong> Tareas por vencer pronto:</strong>
      <ul>
        <li v-for="t in urgentTasks" :key="t.id">{{ t.title }} - Vence: {{ t.dueDate }}</li>
      </ul>
    </div>

    <div>
      <input v-model="filters.keyword" placeholder="Buscar..." @change="fetchTasks" />
      <select v-model="filters.status" @change="fetchTasks">
        <option value="">Todos</option>
        <option value="PENDING">Pendientes</option>
        <option value="COMPLETED">Completadas</option>
      </select>
    </div>

    <hr />

    <h3>Nueva Tarea</h3>
    <form @submit.prevent="createTask">
      <input v-model="taskForm.title" placeholder="Título" required />
      <input v-model="taskForm.description" placeholder="Descripción" required />
      <input v-model="taskForm.dueDate" type="date" required title="Fecha de vencimiento" />

      <select v-model="taskForm.sectorId" required>
        <option value="" disabled>Selecciona Sector</option>
        <option v-for="s in sectorsList" :key="s.id" :value="s.id">{{ s.name }}</option>
      </select>

      <div id="task-map" style="height: 300px; width: 100%; margin: 10px 0"></div>

      <button type="submit" :disabled="!taskForm.latitude">Guardar Tarea</button>
    </form>

    <hr />

    <table border="1" width="100%">
      <thead>
        <tr>
          <th>Título</th>
          <th>Estado</th>
          <th>Sector</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="task in tasks" :key="task.id">
          <td>{{ task.title }}</td>
          <td>{{ task.status }}</td>
          <td>{{ task.sectorName }}</td>
          <td>
            <button v-if="task.status === 'PENDING'" @click="complete(task.id)">Completar</button>
            <button @click="remove(task.id)">Eliminar</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, onBeforeUnmount, nextTick, computed } from 'vue'
import taskApi from '@/api/task.js'
import sectorApi from '@/api/sector.js'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'

// Iconos Leaflet
import markerIconUrl from 'leaflet/dist/images/marker-icon.png'
import markerShadowUrl from 'leaflet/dist/images/marker-shadow.png'
L.Marker.prototype.options.icon = L.icon({
  iconUrl: markerIconUrl,
  shadowUrl: markerShadowUrl,
  iconAnchor: [12, 41],
})

const tasks = ref([])
const sectorsList = ref([])
const filters = reactive({ status: '', keyword: '' })

const taskForm = reactive({
  title: '',
  description: '',
  dueDate: '',
  sectorId: '',
  latitude: null,
  longitude: null,
})
let map = null
let marker = null

const urgentTasks = computed(() => {
  return tasks.value.filter(
    (t) =>
      t.status === 'PENDING' && new Date(t.dueDate).getTime() - new Date().getTime() < 172800000,
  ) // 48 horas
})

const cleanFilters = () => {
  const params = {}
  if (filters.status) params.status = filters.status
  if (filters.keyword) params.keyword = filters.keyword
  return params
}

const normalizeTask = (task) => ({
  ...task,
  sectorName: task.sectorName || task.sector?.name || task.sector?.label || 'Sin sector',
})

onMounted(async () => {
  await fetchTasks()
  sectorsList.value = await sectorApi.getAllSectors()
  await nextTick()

  map = L.map('task-map').setView([-33.4489, -70.6693], 13)
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© OpenStreetMap',
  }).addTo(map)

  map.on('click', (e) => {
    taskForm.latitude = e.latlng.lat
    taskForm.longitude = e.latlng.lng
    if (marker) map.removeLayer(marker)
    marker = L.marker([taskForm.latitude, taskForm.longitude]).addTo(map)
  })

  map.invalidateSize(true)
})

onBeforeUnmount(() => {
  if (map) {
    map.off()
    map.remove()
    map = null
    marker = null
  }
})

const fetchTasks = async () => {
  const data = await taskApi.getTasks(cleanFilters())
  tasks.value = Array.isArray(data) ? data.map(normalizeTask) : []
}

const resetForm = () => {
  Object.assign(taskForm, {
    title: '',
    description: '',
    dueDate: '',
    sectorId: '',
    latitude: null,
    longitude: null,
  })
}

const createTask = async () => {
  await taskApi.createTask(taskForm)
  resetForm()
  if (marker) {
    map.removeLayer(marker)
    marker = null
  }
  await fetchTasks()
}

const complete = async (id) => {
  await taskApi.completeTask(id)
  await fetchTasks()
}
const remove = async (id) => {
  await taskApi.deleteTask(id)
  await fetchTasks()
}
</script>

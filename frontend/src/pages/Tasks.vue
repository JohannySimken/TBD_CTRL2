<template>
  <div class="page-container">
    <div class="header-actions">
      <h2>Gestión de Tareas</h2>
      <button @click="openCreateForm" class="btn-primary">+ Nueva Tarea</button>
    </div>

    <div class="filters-panel card">
      <div class="form-group">
        <label>Buscar</label>
        <input v-model="filters.keyword" placeholder="Buscar por título o descripción..." @change="fetchTasks" />
      </div>
      <div class="form-group">
        <label>Estado</label>
        <select v-model="filters.status" @change="fetchTasks">
          <option value="">Todos</option>
          <option value="PENDING">Pendientes</option>
          <option value="COMPLETED">Completadas</option>
          <option value="EXPIRED">Expiradas</option>
        </select>
      </div>
    </div>

    <div v-if="showForm" class="form-panel card">
      <h3>Nueva Tarea</h3>
      <form @submit.prevent="createTask">
        <div class="form-grid">
          <div class="form-group">
            <label>Título</label>
            <input v-model="taskForm.title" placeholder="Título de la tarea" required />
          </div>
          <div class="form-group">
            <label>Comuna</label>
            <select v-model="taskForm.sectorId" required @change="onSectorChange">
              <option value="" disabled>Selecciona una comuna</option>
              <option v-for="s in sectorsList" :key="s.id" :value="s.id">{{ s.name }}</option>
            </select>
          </div>
          <div class="form-group">
            <label>Fecha y hora de vencimiento</label>
            <input v-model="taskForm.dueDate" type="datetime-local" :min="nowLocal" required />
          </div>
        </div>
        <div class="form-group full-width">
          <label>Descripción</label>
          <textarea v-model="taskForm.description" placeholder="Descripción de la tarea" required rows="3"></textarea>
        </div>
        <div class="form-actions">
          <button type="button" @click="showForm = false" class="btn-secondary">Cancelar</button>
          <button type="submit" class="btn-success">Guardar Tarea</button>
        </div>
      </form>
    </div>

    <!-- Modal de edición -->
    <div v-if="editModal.visible" class="modal-overlay" @click.self="closeEdit">
      <div class="modal-box card">
        <h3>Editar Tarea</h3>
        <form @submit.prevent="saveEdit">
          <div class="form-group">
            <label>Título</label>
            <input v-model="editForm.title" required />
          </div>

          <div class="form-group">
            <label>Descripción</label>
            <textarea v-model="editForm.description" required rows="3"></textarea>
          </div>

          <div class="form-grid">
            <div class="form-group">
              <label>Fecha y hora de vencimiento</label>
              <input v-model="editForm.dueDate" type="datetime-local" required />
            </div>

            <div class="form-group">
              <label>Comuna</label>
              <select v-model="editForm.sectorId" required @change="onEditSectorChange">
                <option value="" disabled>Selecciona una comuna</option>
                <option v-for="s in sectorsList" :key="s.id" :value="s.id">{{ s.name }}</option>
              </select>
            </div>
          </div>

          <div class="form-actions">
            <button type="button" class="btn-secondary" @click="closeEdit">Cancelar</button>
            <button type="submit" class="btn-success" :disabled="editModal.saving">
              {{ editModal.saving ? 'Guardando...' : 'Guardar cambios' }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="tasks.length === 0" class="empty-state">No hay tareas registradas.</div>

    <table v-else class="data-table">
      <thead>
        <tr>
          <th>Título</th>
          <th>Estado</th>
          <th>Comuna</th>
          <th>Vencimiento</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="task in tasks" :key="task.id">
          <td><strong>{{ task.title }}</strong></td>
          <td>
            <label class="status-check">
              <input
                type="checkbox"
                :checked="task.status === 'COMPLETED'"
                :disabled="task.status === 'EXPIRED'"
                @change="toggleStatus(task)"
              />
              <span :class="'badge badge-' + task.status.toLowerCase()">{{ task.status }}</span>
            </label>
          </td>
          <td>{{ task.sectorName }}</td>
          <td>{{ formatDueDate(task.dueDate) }}</td>
          <td class="actions-cell">
            <button @click="openEdit(task)" class="btn-secondary btn-sm">Editar</button>
            <button @click="remove(task.id)" class="btn-danger btn-sm">Eliminar</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import taskApi from '@/api/task.js'
import sectorApi from '@/api/sector.js'

const tasks = ref([])
const sectorsList = ref([])
const filters = reactive({ status: '', keyword: '' })
const showForm = ref(false)
const nowLocal = ref('')

const toLocalDateTimeString = (date) => {
  const pad = (n) => String(n).padStart(2, '0')
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}T${pad(date.getHours())}:${pad(date.getMinutes())}`
}

// Coordenadas por defecto (centro de Santiago) — la columna location es NOT NULL en la BD.
const DEFAULT_LAT = -33.4489
const DEFAULT_LNG = -70.6693

const taskForm = reactive({
  title: '',
  description: '',
  dueDate: '',
  sectorId: '',
  latitude: DEFAULT_LAT,
  longitude: DEFAULT_LNG,
})

// Estado del modal de edición
const editModal = reactive({ visible: false, taskId: null, saving: false })
const editForm = reactive({
  title: '',
  description: '',
  dueDate: '',
  sectorId: '',
  latitude: DEFAULT_LAT,
  longitude: DEFAULT_LNG,
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

const formatDueDate = (dueDate) => {
  if (!dueDate) return '—'
  const date = new Date(dueDate)
  if (Number.isNaN(date.getTime())) return dueDate
  return date.toLocaleString('es-CL', { dateStyle: 'medium', timeStyle: 'short' })
}

// Al cambiar comuna en el form de creación, actualizar coordenadas
const onSectorChange = () => {
  const sector = sectorsList.value.find((s) => s.id === taskForm.sectorId)
  if (sector) {
    taskForm.latitude = sector.latitude
    taskForm.longitude = sector.longitude
  }
}

// Al cambiar comuna en el form de edición, actualizar coordenadas
const onEditSectorChange = () => {
  const sector = sectorsList.value.find((s) => s.id === editForm.sectorId)
  if (sector) {
    editForm.latitude = sector.latitude
    editForm.longitude = sector.longitude
  }
}

onMounted(async () => {
  await fetchTasks()
  sectorsList.value = await sectorApi.getAllSectors()
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
    latitude: DEFAULT_LAT,
    longitude: DEFAULT_LNG,
  })
}

const openCreateForm = () => {
  resetForm()
  nowLocal.value = toLocalDateTimeString(new Date())
  showForm.value = true
}

const createTask = async () => {
  try {
    await taskApi.createTask(taskForm)
    resetForm()
    showForm.value = false
    await fetchTasks()
  } catch (error) {
    const msg = error.response?.data?.message || error.response?.data || error.message || 'Error desconocido'
    alert('Error al guardar la tarea: ' + msg)
  }
}

// Abrir modal con datos de la tarea existente
const openEdit = (task) => {
  const sector = sectorsList.value.find((s) => s.name === task.sectorName)
  Object.assign(editForm, {
    title: task.title,
    description: task.description || '',
    dueDate: task.dueDate ? task.dueDate.slice(0, 16) : '',
    sectorId: sector?.id ?? '',
    latitude: task.latitude ?? DEFAULT_LAT,
    longitude: task.longitude ?? DEFAULT_LNG,
  })
  editModal.taskId = task.id
  editModal.visible = true
}

const closeEdit = () => {
  editModal.visible = false
  editModal.taskId = null
}

const saveEdit = async () => {
  editModal.saving = true
  try {
    await taskApi.updateTask(editModal.taskId, editForm)
    closeEdit()
    await fetchTasks()
  } catch (error) {
    const msg = error.response?.data?.message || error.response?.data || error.message || 'Error desconocido'
    alert('Error al editar la tarea: ' + msg)
  } finally {
    editModal.saving = false
  }
}

const toggleStatus = async (task) => {
  try {
    if (task.status === 'COMPLETED') {
      await taskApi.revertTask(task.id)
    } else {
      await taskApi.completeTask(task.id)
    }
    await fetchTasks()
  } catch (error) {
    console.error('toggleStatus error:', error)
  }
}

const remove = async (id) => {
  if (!confirm('¿Eliminar esta tarea?')) return
  await taskApi.deleteTask(id)
  await fetchTasks()
}
</script>

<style scoped>
.page-container {
  padding: 10px 0;
}
.header-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.card {
  background: #f8f9fa;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 25px;
  border: 1px solid #dee2e6;
}
.filters-panel {
  display: flex;
  gap: 15px;
  align-items: flex-end;
}
.filters-panel .form-group {
  flex: 1;
  margin-bottom: 0;
}
.form-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
}
.full-width {
  grid-column: 1 / -1;
}
.form-group {
  margin-bottom: 12px;
}
.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: 500;
  font-size: 0.9em;
}
.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 8px;
  border: 1px solid #ced4da;
  border-radius: 4px;
  box-sizing: border-box;
  font-size: 0.95em;
}
.form-group textarea {
  resize: vertical;
}
.form-actions {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
  margin-top: 15px;
}

/* Modal */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.45);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}
.modal-box {
  width: 100%;
  max-width: 520px;
  margin-bottom: 0;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
}
.modal-box h3 {
  margin-top: 0;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}
.data-table th,
.data-table td {
  padding: 12px 15px;
  text-align: left;
  border-bottom: 1px solid #eee;
}
.data-table th {
  background-color: #2c3e50;
  color: white;
}
.actions-cell {
  white-space: nowrap;
}
.empty-state {
  color: #999;
  font-style: italic;
  padding: 20px 0;
}

button {
  padding: 8px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: bold;
}
.btn-primary {
  background: #0d6efd;
  color: white;
}
.btn-secondary {
  background: #6c757d;
  color: white;
}
.btn-success {
  background: #198754;
  color: white;
}
.btn-danger {
  background: #dc3545;
  color: white;
}
.btn-sm {
  padding: 5px 8px;
  font-size: 0.85em;
  margin-right: 4px;
}

/* Checkbox + badge de estado */
.status-check {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  white-space: nowrap;
}
.status-check input[type='checkbox'] {
  width: 16px;
  height: 16px;
  cursor: pointer;
  accent-color: #198754;
}
.badge {
  padding: 3px 8px;
  border-radius: 12px;
  font-size: 0.8em;
  font-weight: 700;
  letter-spacing: 0.03em;
}
.badge-pending {
  background: #fff3cd;
  color: #856404;
}
.badge-completed {
  background: #d1e7dd;
  color: #0a3622;
}
.badge-expired {
  background: #f8d7da;
  color: #58151c;
}
</style>

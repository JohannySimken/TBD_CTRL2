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

    <!-- Formulario nueva tarea -->
    <h3>Nueva Tarea</h3>
    <form @submit.prevent="createTask">
      <div class="form-group">
        <label>Título</label>
        <input v-model="taskForm.title" placeholder="Título de la tarea" required />
      </div>

      <div class="form-group">
        <label>Descripción</label>
        <textarea v-model="taskForm.description" placeholder="Descripción de la tarea" required rows="3"></textarea>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>Fecha de vencimiento</label>
          <input v-model="taskForm.dueDate" type="date" required />
        </div>

        <div class="form-group">
          <label>Comuna</label>
          <select v-model="taskForm.sectorId" required @change="onSectorChange">
            <option value="" disabled>Selecciona una comuna</option>
            <option v-for="s in sectorsList" :key="s.id" :value="s.id">{{ s.name }}</option>
          </select>
        </div>
      </div>

      <button type="submit">Guardar Tarea</button>
    </form>

    <hr />

    <!-- Modal de edición -->
    <div v-if="editModal.visible" class="modal-overlay" @click.self="closeEdit">
      <div class="modal-box">
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

          <div class="form-row">
            <div class="form-group">
              <label>Fecha de vencimiento</label>
              <input v-model="editForm.dueDate" type="date" required />
            </div>

            <div class="form-group">
              <label>Comuna</label>
              <select v-model="editForm.sectorId" required @change="onEditSectorChange">
                <option value="" disabled>Selecciona una comuna</option>
                <option v-for="s in sectorsList" :key="s.id" :value="s.id">{{ s.name }}</option>
              </select>
            </div>
          </div>

          <div class="modal-actions">
            <button type="button" class="btn-secondary" @click="closeEdit">Cancelar</button>
            <button type="submit" class="btn-primary" :disabled="editModal.saving">
              {{ editModal.saving ? 'Guardando...' : 'Guardar cambios' }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <table border="1" width="100%">
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
          <td>{{ task.title }}</td>
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
          <td>{{ task.dueDate }}</td>
          <td>
            <button @click="openEdit(task)">Editar</button>
            <button @click="remove(task.id)">Eliminar</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import taskApi from '@/api/task.js'
import sectorApi from '@/api/sector.js'

const tasks = ref([])
const sectorsList = ref([])
const filters = reactive({ status: '', keyword: '' })

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

// Al cambiar comuna en el form de creación, actualizar coordenadas
const onSectorChange = () => {
  const sector = sectorsList.value.find((s) => s.id === taskForm.sectorId)
  if (sector) {
    taskForm.latitude = sector.latitude
    taskForm.longitude = sector.longitude
    console.log(`📌 [onSectorChange] Sector: ${sector.name} | lat: ${sector.latitude} | lng: ${sector.longitude}`)
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
  // ── DEBUG: ver qué devuelve el API de sectores ──
  console.group('🌎 [Tasks DEBUG] Sectores cargados desde API')
  console.table(
    sectorsList.value.map((s) => ({
      id: s.id,
      nombre: s.name,
      latitud: s.latitude,
      longitud: s.longitude,
    }))
  )
  console.groupEnd()
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

const createTask = async () => {
  // ── DEBUG: ver qué se envía al backend ──
  console.log('🚀 [createTask] Datos enviados al backend:', {
    title: taskForm.title,
    sectorId: taskForm.sectorId,
    latitude: taskForm.latitude,
    longitude: taskForm.longitude,
    dueDate: taskForm.dueDate,
  })
  try {
    await taskApi.createTask(taskForm)
    resetForm()
    await fetchTasks()
  } catch (error) {
    const msg = error.response?.data?.message || error.response?.data || error.message || 'Error desconocido'
    alert('Error al guardar la tarea: ' + msg)
    console.error('createTask error:', error.response || error)
  }
}

// Abrir modal con datos de la tarea existente
const openEdit = (task) => {
  const sector = sectorsList.value.find((s) => s.name === task.sectorName)
  Object.assign(editForm, {
    title: task.title,
    description: task.description || '',
    dueDate: task.dueDate,
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
    console.error('saveEdit error:', error.response || error)
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

const complete = async (id) => {
  await taskApi.completeTask(id)
  await fetchTasks()
}
const remove = async (id) => {
  await taskApi.deleteTask(id)
  await fetchTasks()
}
</script>

<style scoped>
.form-group {
  margin-bottom: 12px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.form-group label {
  font-weight: 600;
  font-size: 0.9em;
}

.form-group input,
.form-group select,
.form-group textarea {
  padding: 8px 10px;
  border: 1px solid #ced4da;
  border-radius: 4px;
  font-size: 0.95em;
  width: 100%;
  box-sizing: border-box;
}

.form-group textarea {
  resize: vertical;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
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
  background: white;
  border-radius: 8px;
  padding: 28px 32px;
  width: 100%;
  max-width: 520px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
}

.modal-box h3 {
  margin-top: 0;
  margin-bottom: 20px;
}

.modal-actions {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
  margin-top: 18px;
}

button {
  padding: 7px 14px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: 600;
  margin-right: 4px;
}

.btn-primary {
  background: #0d6efd;
  color: white;
}

.btn-secondary {
  background: #6c757d;
  color: white;
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

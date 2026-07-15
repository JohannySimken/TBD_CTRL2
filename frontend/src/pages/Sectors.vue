<template>
  <div class="page-container">
    <div class="header-actions">
      <h2>Gestión de Sectores Geográficos</h2>
      <button v-if="isAdmin" @click="openCreateForm" class="btn-primary">+ Nuevo Sector</button>
    </div>

    <div v-if="showForm" class="form-panel card">
      <h3>Crear Nuevo Sector</h3>
      <form @submit.prevent="submitSector">
        <div class="form-grid">
          <div class="form-group">
            <label>Nombre del Sector</label>
            <input
              v-model="form.name"
              type="text"
              required
              placeholder="Ej. Reparación de Semáforos"
            />
          </div>
          <div class="form-group">
            <label>Categoría</label>
            <input v-model="form.category" type="text" required placeholder="Ej. Vialidad" />
          </div>
          <div class="form-group">
            <label>Latitud (Centroide)</label>
            <input v-model.number="form.latitude" type="number" step="any" required />
          </div>
          <div class="form-group">
            <label>Longitud (Centroide)</label>
            <input v-model.number="form.longitude" type="number" step="any" required />
          </div>
        </div>
        <div class="form-group full-width">
          <label>Descripción</label>
          <textarea v-model="form.description" rows="3" required></textarea>
        </div>
        <div class="form-actions">
          <button type="button" @click="showForm = false" class="btn-secondary">Cancelar</button>
          <button type="submit" class="btn-success" :disabled="isSubmitting">
            {{ isSubmitting ? 'Guardando...' : 'Guardar Sector' }}
          </button>
        </div>
      </form>
    </div>

    <div v-if="isLoading" class="loading">Cargando sectores...</div>
    <div v-else-if="sectors.length === 0" class="empty-state">No hay sectores registrados.</div>

    <table v-else class="data-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Nombre</th>
          <th>Categoría</th>
          <th>Descripción</th>
          <th v-if="isAdmin">Acciones</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="sector in sectors" :key="sector.id">
          <td>{{ sector.id }}</td>
          <td>
            <strong>{{ sector.name }}</strong>
          </td>
          <td>
            <span class="category-badge">{{ sector.category }}</span>
          </td>
          <td class="desc-cell">{{ sector.description }}</td>
          <td v-if="isAdmin" class="actions-cell">
            <button @click="removeSector(sector.id)" class="btn-danger btn-sm">🗑 Eliminar</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import sectorApi from '@/api/sector.js'

const sectors = ref([])
const isLoading = ref(true)
const isSubmitting = ref(false)
const showForm = ref(false)

const form = reactive({
  name: '',
  category: '',
  description: '',
  latitude: null,
  longitude: null,
})

const isAdmin = computed(() => {
  const userStr = localStorage.getItem('loa_user')
  if (!userStr) return false
  try {
    return JSON.parse(userStr).role === 'ADMIN'
  } catch (e) {
    return false
  }
})

onMounted(() => {
  fetchSectors()
})

const fetchSectors = async () => {
  isLoading.value = true
  try {
    sectors.value = await sectorApi.getAllSectors()
  } catch (error) {
    console.error('Error cargando sectores:', error)
  } finally {
    isLoading.value = false
  }
}

const openCreateForm = () => {
  // Limpiar formulario
  Object.assign(form, { name: '', category: '', description: '', latitude: null, longitude: null })
  showForm.value = true
}

const submitSector = async () => {
  isSubmitting.value = true
  try {
    await sectorApi.createSector(form)
    showForm.value = false
    await fetchSectors()
  } catch (error) {
    alert(
      error.response?.data?.message || 'Error al crear el sector. Verifica restricciones únicas.',
    )
  } finally {
    isSubmitting.value = false
  }
}

const removeSector = async (id) => {
  if (!confirm('¿Eliminar este sector? Esto podría afectar las tareas asociadas.')) return
  try {
    await sectorApi.deleteSector(id)
    sectors.value = sectors.value.filter((s) => s.id !== id)
  } catch (error) {
    alert('Error al eliminar. Es posible que el sector tenga tareas activas.')
  }
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
.form-panel {
  background: #f8f9fa;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 25px;
  border: 1px solid #dee2e6;
}
.form-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
}
.full-width {
  grid-column: 1 / -1;
}
.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: 500;
  font-size: 0.9em;
}
.form-group input,
.form-group textarea {
  width: 100%;
  padding: 8px;
  border: 1px solid #ced4da;
  border-radius: 4px;
  box-sizing: border-box;
}
.form-actions {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
  margin-top: 15px;
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
.category-badge {
  background: #e0eaf5;
  color: #2c3e50;
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 0.85em;
  font-weight: bold;
}
.desc-cell {
  max-width: 300px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.actions-cell {
  white-space: nowrap;
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
}
</style>

<template>
  <div class="stats-page">
    <h2>Dashboard Estadístico</h2>

    <div v-if="loading" class="loading-state">Cargando estadísticas...</div>

    <template v-else>

      <!-- ───────────────────────── SECCIÓN 1 ───────────────────────── -->
      <section class="stat-section">
        <div class="section-header">
          <span class="section-num">1</span>
          <div><h3>¿Cuántas tareas completadas ha hecho el usuario por sector?</h3></div>
        </div>
        <div v-if="tasksBySector.length === 0" class="empty">Sin datos disponibles.</div>
        <table v-else class="stat-table">
          <thead><tr><th>Comuna</th><th>Tareas completadas</th></tr></thead>
          <tbody>
            <tr v-for="row in tasksBySector" :key="row.sectorName">
              <td>{{ row.sectorName }}</td>
              <td><span class="pill">{{ row.count }}</span></td>
            </tr>
          </tbody>
        </table>
      </section>

      <div class="divider"></div>

      <!-- ───────────────────────── SECCIÓN 2 ───────────────────────── -->
      <section class="stat-section">
        <div class="section-header">
          <span class="section-num">2</span>
          <div><h3>¿Cuál es la tarea más cercana al usuario que esté pendiente?</h3></div>
        </div>
        <div v-if="!closestTask" class="empty">No hay tareas pendientes registradas.</div>
        <div v-else class="info-card">
          <div class="info-row"><span class="info-label">Título</span><span>{{ closestTask.title }}</span></div>
          <div class="info-row"><span class="info-label">Descripción</span><span>{{ closestTask.description || '—' }}</span></div>
          <div class="info-row"><span class="info-label">Comuna</span><span>{{ closestTask.sector?.name || '—' }}</span></div>
          <div class="info-row"><span class="info-label">Vencimiento</span><span>{{ closestTask.dueDate }}</span></div>
          <div class="info-row"><span class="info-label">Estado</span><span class="badge badge-pending">PENDING</span></div>
        </div>
      </section>

      <div class="divider"></div>

      <!-- ───────────────────────── SECCIÓN 3 ───────────────────────── -->
      <section class="stat-section">
        <div class="section-header">
          <span class="section-num">3</span>
          <div><h3>¿Cuál es el sector con más tareas completadas en un radio de 2 km del usuario?</h3></div>
        </div>
        <div v-if="!top2km" class="empty">Sin tareas completadas en ese radio.</div>
        <div v-else class="info-card highlight">
          <div class="info-row"><span class="info-label">Comuna</span><strong>{{ top2km.sectorName }}</strong></div>
          <div class="info-row"><span class="info-label">Tareas completadas</span><span class="pill">{{ top2km.count }}</span></div>
        </div>
      </section>

      <div class="divider"></div>

      <!-- ───────────────────────── SECCIÓN 4 ───────────────────────── -->
      <section class="stat-section">
        <div class="section-header">
          <span class="section-num">4</span>
          <div><h3>¿Cuál es el promedio de distancia de las tareas completadas respecto a la ubicación del usuario?</h3></div>
        </div>

        <p class="section-desc">Haz clic en el mapa para elegir un punto de referencia y calcular el promedio.</p>
        <div id="custom-point-map" class="custom-map"></div>
        <p v-if="customLat !== null" class="coord-hint">
          📍 Punto seleccionado: {{ customLat.toFixed(5) }}, {{ customLng.toFixed(5) }}
        </p>
        <button
          class="btn-calc"
          :disabled="customLat === null || customLoading"
          @click="calculateCustomAvg"
        >
          {{ customLoading ? 'Calculando...' : 'Calcular promedio' }}
        </button>
        <p v-if="customError" class="empty">{{ customError }}</p>
        <div v-if="customAvgDist !== null" class="big-metric">
          <span class="metric-value">{{ (Number(customAvgDist) / 1000).toFixed(2) }}</span>
          <span class="metric-unit">km</span>
        </div>
      </section>

      <div class="divider"></div>

      <!-- ───────────────────────── SECCIÓN 5 ───────────────────────── -->
      <section class="stat-section">
        <div class="section-header">
          <span class="section-num">5</span>
          <div><h3>¿En qué sectores geográficos se concentran la mayoría de las tareas pendientes? (agrupación espacial)</h3></div>
        </div>
        <div v-if="clusters.length === 0" class="empty">Sin datos de agrupación.</div>
        <table v-else class="stat-table">
          <thead><tr><th>Comuna</th><th>Tareas pendientes</th></tr></thead>
          <tbody>
            <tr v-for="c in clusters" :key="c.sectorName">
              <td>{{ c.sectorName }}</td>
              <td>
                <div class="bar-cell">
                  <div class="bar" :style="{ width: barWidth(c.pendingCount, maxCluster) + '%' }"></div>
                  <span>{{ c.pendingCount }}</span>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </section>

      <div class="divider"></div>

      <!-- ───────────────────────── SECCIÓN 6 ───────────────────────── -->
      <section class="stat-section">
        <div class="section-header">
          <span class="section-num">6</span>
          <div><h3>¿Cuántas tareas ha realizado cada usuario por sector?</h3></div>
        </div>
        <div v-if="ranking.length === 0" class="empty">Sin datos globales.</div>
        <table v-else class="stat-table">
          <thead><tr><th>Usuario</th><th>Comuna</th><th>Tareas</th></tr></thead>
          <tbody>
            <tr v-for="(row, i) in ranking" :key="i">
              <td>{{ row.username }}</td>
              <td>{{ row.sectorName }}</td>
              <td><span class="pill">{{ row.count }}</span></td>
            </tr>
          </tbody>
        </table>
      </section>

      <div class="divider"></div>

      <!-- ───────────────────────── SECCIÓN 7 ───────────────────────── -->
      <section class="stat-section">
        <div class="section-header">
          <span class="section-num">7</span>
          <div><h3>¿Cuál es el sector con más tareas completadas dentro de un radio de 5 km desde la ubicación del usuario?</h3></div>
        </div>
        <div v-if="!top5km" class="empty">Sin tareas completadas en ese radio.</div>
        <div v-else class="info-card highlight">
          <div class="info-row"><span class="info-label">Comuna</span><strong>{{ top5km.sectorName }}</strong></div>
          <div class="info-row"><span class="info-label">Tareas completadas</span><span class="pill">{{ top5km.count }}</span></div>
        </div>
      </section>

      <div class="divider"></div>

      <!-- ───────────────────────── SECCIÓN 8 ───────────────────────── -->
      <section class="stat-section">
        <div class="section-header">
          <span class="section-num">8</span>
          <div><h3>¿Cuál es el promedio de distancia entre las tareas completadas y el punto registrado del usuario?</h3></div>
        </div>
        <div class="big-metric">
          <span class="metric-value">{{ avgDist !== null ? (Number(avgDist) / 1000).toFixed(2) : '—' }}</span>
          <span class="metric-unit">km</span>
        </div>
        <p class="section-desc">Usando la ubicación registrada del usuario en el sistema.</p>
      </section>

    </template>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import statsApi from '@/api/stats.js'
import taskApi from '@/api/task.js'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'
import markerIconUrl from 'leaflet/dist/images/marker-icon.png'
import markerShadowUrl from 'leaflet/dist/images/marker-shadow.png'

L.Marker.prototype.options.icon = L.icon({
  iconUrl: markerIconUrl,
  shadowUrl: markerShadowUrl,
  iconAnchor: [12, 41],
})

const loading = ref(true)
const avgDist = ref(null)
const closestTask = ref(null)
const top2km = ref(null)
const top5km = ref(null)
const clusters = ref([])
const ranking = ref([])
const tasksBySector = ref([])

// Sección 4: punto elegido en el mapa
const customLat = ref(null)
const customLng = ref(null)
const customAvgDist = ref(null)
const customLoading = ref(false)
const customError = ref('')
let customMap = null
let customMarker = null

const maxCluster = computed(() =>
  clusters.value.reduce((max, c) => Math.max(max, c.pendingCount), 1),
)

const barWidth = (val, max) => Math.round((val / max) * 100)

const initCustomMap = () => {
  customMap = L.map('custom-point-map').setView([-33.4489, -70.6693], 11)
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© OpenStreetMap',
  }).addTo(customMap)

  customMap.on('click', (e) => {
    customLat.value = e.latlng.lat
    customLng.value = e.latlng.lng
    customAvgDist.value = null
    customError.value = ''
    if (customMarker) customMap.removeLayer(customMarker)
    customMarker = L.marker([e.latlng.lat, e.latlng.lng]).addTo(customMap)
  })
}

const calculateCustomAvg = async () => {
  if (customLat.value === null) return
  customLoading.value = true
  customError.value = ''
  try {
    customAvgDist.value = await statsApi.getAvgDistanceCompletedCustom(customLat.value, customLng.value)
  } catch {
    customError.value = 'Error al calcular el promedio con ese punto.'
  } finally {
    customLoading.value = false
  }
}

onMounted(async () => {
  try {
    const [resAvg, resClosest, res2k, res5k, resClusters, resRank, resBySector, allPending] =
      await Promise.all([
        statsApi.getAvgDistanceCompleted(),
        statsApi.getClosestPendingTask(),
        statsApi.getTopSector2km(),
        statsApi.getTopSector5km(),
        statsApi.getPendingBySectorCluster(),
        statsApi.getTasksPerUserBySector(),
        statsApi.getTasksBySector(),
        taskApi.getTasks({ status: 'PENDING' }),
      ])

    avgDist.value = resAvg
    closestTask.value = resClosest
    top2km.value = res2k
    top5km.value = res5k
    clusters.value = resClusters
    ranking.value = resRank
    tasksBySector.value = resBySector

    // ── DEBUG: tabla de tareas pendientes con coordenadas ──────────────────
    console.group('📍 [Stats DEBUG] Tareas PENDING con ubicación')
    console.table(
      allPending.map((t) => ({
        id: t.id,
        titulo: t.title,
        sector: t.sectorName,
        vencimiento: t.dueDate,
        latitud: t.latitude,
        longitud: t.longitude,
        'es la más cercana?': resClosest && t.id === resClosest.id ? '✅ SÍ' : '',
      }))
    )
    console.log('🏆 Más cercana según backend:', resClosest)
    console.groupEnd()
    // ───────────────────────────────────────────────────────────────────────
  } catch (err) {
    console.error('Error cargando estadísticas:', err)
  } finally {
    loading.value = false
    await nextTick()
    initCustomMap()
  }
})
</script>

<style scoped>
.stats-page { padding: 4px 0; }
h2 { margin-bottom: 28px; font-size: 1.5rem; }

.stat-section { padding: 20px 0; }

.section-header {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  margin-bottom: 16px;
}

.section-num {
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 36px;
  height: 36px;
  background: #2c3e50;
  color: white;
  border-radius: 50%;
  font-weight: 700;
  font-size: 0.95rem;
  margin-top: 2px;
  flex-shrink: 0;
}

.section-header h3 { margin: 0; font-size: 1.05rem; }

.section-desc { margin: 0 0 12px; font-size: 0.88rem; color: #666; }

.divider { border: none; border-top: 1px solid #dee2e6; margin: 4px 0; }

/* Mapa sección 4 */
.custom-map {
  height: 280px;
  width: 100%;
  border-radius: 6px;
  border: 1px solid #dee2e6;
  margin-bottom: 10px;
}

.coord-hint {
  margin: 0 0 10px;
  font-size: 0.88rem;
  color: #555;
}

.btn-calc {
  padding: 8px 20px;
  background: #2c3e50;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: 600;
  margin-bottom: 12px;
}

.btn-calc:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Tabla */
.stat-table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  box-shadow: 0 1px 3px rgba(0,0,0,0.08);
  border-radius: 6px;
  overflow: hidden;
}
.stat-table th, .stat-table td {
  padding: 10px 14px;
  text-align: left;
  border-bottom: 1px solid #f0f0f0;
  font-size: 0.92rem;
}
.stat-table th { background: #2c3e50; color: white; font-weight: 600; }
.stat-table tbody tr:last-child td { border-bottom: none; }
.stat-table tbody tr:hover { background: #f8f9fa; }

/* Info card */
.info-card {
  background: #f8f9fa;
  border: 1px solid #dee2e6;
  border-radius: 8px;
  padding: 16px 20px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  max-width: 520px;
}
.info-card.highlight {
  border-left: 4px solid #2c3e50;
  background: #eef1f5;
}
.info-row { display: flex; align-items: center; gap: 12px; font-size: 0.93rem; }
.info-label {
  min-width: 110px;
  font-weight: 600;
  color: #555;
  font-size: 0.85rem;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

/* Métrica grande */
.big-metric {
  display: flex;
  align-items: baseline;
  gap: 8px;
  padding: 10px 0;
}
.metric-value { font-size: 3rem; font-weight: 700; color: #2c3e50; line-height: 1; }
.metric-unit { font-size: 1.2rem; color: #666; }

/* Pill */
.pill {
  background: #e0eaf5;
  color: #2c3e50;
  padding: 2px 10px;
  border-radius: 12px;
  font-weight: 700;
  font-size: 0.85rem;
}

/* Barra */
.bar-cell { display: flex; align-items: center; gap: 10px; }
.bar { height: 10px; background: #3498db; border-radius: 5px; min-width: 4px; transition: width 0.3s; }

/* Badge */
.badge { padding: 3px 8px; border-radius: 12px; font-size: 0.8em; font-weight: 700; }
.badge-pending { background: #fff3cd; color: #856404; }

.loading-state { color: #666; padding: 20px 0; }
.empty { color: #999; font-style: italic; font-size: 0.9rem; padding: 6px 0; }
</style>

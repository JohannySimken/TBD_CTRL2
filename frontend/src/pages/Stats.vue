<template>
  <div>
    <h2>Dashboard Espacial</h2>

    <ul>
      <li><strong>Distancia Promedio a Completadas:</strong> {{ avgDist }} km</li>
      <li>
        <strong>Tarea Pendiente Más Cercana:</strong>
        {{ closestTask ? closestTask.title : 'Ninguna' }}
      </li>
      <li>
        <strong>Sector Top 2km:</strong>
        {{ top2km ? top2km.sectorName + ' (' + top2km.count + ')' : 'N/A' }}
      </li>
      <li>
        <strong>Sector Top 5km:</strong>
        {{ top5km ? top5km.sectorName + ' (' + top5km.count + ')' : 'N/A' }}
      </li>
    </ul>

    <hr />

    <h3>Zonas de Concentración de Tareas Pendientes</h3>
    <div id="cluster-map" style="height: 400px; width: 100%"></div>

    <table border="1" width="100%" style="margin-top: 15px">
      <thead>
        <tr>
          <th>Sector</th>
          <th>Tareas Pendientes</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="c in clusters" :key="c.sectorName">
          <td>{{ c.sectorName }}</td>
          <td>{{ c.pendingCount }}</td>
        </tr>
      </tbody>
    </table>

    <hr />

    <h3>Ranking Global: Tareas por Usuario y Sector</h3>
    <table border="1" width="100%">
      <thead>
        <tr>
          <th>Usuario</th>
          <th>Sector</th>
          <th>Completadas</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(rank, i) in ranking" :key="i">
          <td>{{ rank.username }}</td>
          <td>{{ rank.sectorName }}</td>
          <td>{{ rank.count }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import statsApi from '@/api/stats.js'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'
import parseWKT from 'wellknown'

import markerIconUrl from 'leaflet/dist/images/marker-icon.png'
import markerShadowUrl from 'leaflet/dist/images/marker-shadow.png'
L.Marker.prototype.options.icon = L.icon({
  iconUrl: markerIconUrl,
  shadowUrl: markerShadowUrl,
  iconAnchor: [12, 41],
})

const avgDist = ref(0)
const closestTask = ref(null)
const top2km = ref(null)
const top5km = ref(null)
const clusters = ref([])
const ranking = ref([])

onMounted(async () => {
  const [resAvg, resClosest, res2k, res5k, resClusters, resRank] = await Promise.all([
    statsApi.getAvgDistanceCompleted(),
    statsApi.getClosestPendingTask(),
    statsApi.getTopSector2km(),
    statsApi.getTopSector5km(),
    statsApi.getPendingBySectorCluster(),
    statsApi.getTasksPerUserBySector(),
  ])

  avgDist.value = resAvg
  closestTask.value = resClosest
  top2km.value = res2k
  top5km.value = res5k
  clusters.value = resClusters
  ranking.value = resRank

  const map = L.map('cluster-map').setView([-33.4489, -70.6693], 12)
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map)

  clusters.value.forEach((cluster) => {
    if (cluster.centroidWkt) {
      const geojsonFeature = parseWKT(cluster.centroidWkt)
      L.geoJSON(geojsonFeature)
        .bindPopup(`<b>${cluster.sectorName}</b><br>Tareas pendientes: ${cluster.pendingCount}`)
        .addTo(map)
    }
  })
})
</script>

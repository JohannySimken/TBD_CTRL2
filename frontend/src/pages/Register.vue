<template>
  <div>
    <h2>Registro de Usuario</h2>
    <form @submit.prevent="submitRegister">
      <div>
        <label>Usuario:</label>
        <input v-model="form.username" type="text" required />
      </div>
      <div>
        <label>Email:</label>
        <input v-model="form.email" type="email" required />
      </div>
      <div>
        <label>Contraseña:</label>
        <input v-model="form.password" type="password" required />
      </div>

      <div>
        <label>Selecciona tu ubicación en el mapa (Obligatorio para PostGIS):</label>
        <div id="register-map" style="height: 300px; width: 100%; margin: 10px 0"></div>
        <p v-if="form.latitude">
          Coordenadas: {{ form.latitude.toFixed(4) }}, {{ form.longitude.toFixed(4) }}
        </p>
      </div>

      <button type="submit" :disabled="!form.latitude || isLoading">
        {{ isLoading ? 'Registrando...' : 'Registrar' }}
      </button>
      <p v-if="errorMessage">{{ errorMessage }}</p>
    </form>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import userApi from '@/api/user.js'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'
import markerIconUrl from 'leaflet/dist/images/marker-icon.png'
import markerShadowUrl from 'leaflet/dist/images/marker-shadow.png'
L.Marker.prototype.options.icon = L.icon({
  iconUrl: markerIconUrl,
  shadowUrl: markerShadowUrl,
  iconAnchor: [12, 41],
})

const router = useRouter()
const form = reactive({ username: '', email: '', password: '', latitude: null, longitude: null })
const isLoading = ref(false)
const errorMessage = ref('')
let map = null
let marker = null

onMounted(() => {
  //Centra el mapa en santiago
  map = L.map('register-map').setView([-33.4489, -70.6693], 13)
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© OpenStreetMap',
  }).addTo(map)
  map.on('click', (e) => {
    form.latitude = e.latlng.lat
    form.longitude = e.latlng.lng

    if (marker) map.removeLayer(marker)
    marker = L.marker([form.latitude, form.longitude]).addTo(map)
  })
})

const submitRegister = async () => {
  isLoading.value = true
  try {
    const data = await userApi.register(form)
    if (data && data.token) {
      localStorage.setItem('loa_token', data.token)
      localStorage.setItem('loa_user', JSON.stringify({ username: data.username, role: data.role }))
    }
    router.push('/tasks')
  } catch (error) {
    errorMessage.value = error.response?.data?.message || 'Error en registro'
  } finally {
    isLoading.value = false
  }
}
</script>

import api from './axios.js'

const statsService = {
  /**
   * 1) ¿Cuántas tareas ha hecho el usuario logueado por sector?
   * @returns {Promise<Array>} - Lista de SectorCountDTO { sectorName, count }
   */
  async getTasksBySector() {
    const response = await api.get('/stats/tasks-by-sector')
    return response.data || []
  },

  /**
   * 6) Ranking global: ¿Cuántas tareas ha realizado cada usuario por sector?
   * @returns {Promise<Array>} - Lista de UserSectorCountDTO { username, sectorName, count }
   */
  async getTasksPerUserBySector() {
    const response = await api.get('/stats/tasks-per-user-by-sector')
    return response.data || []
  },

  /**
   * 3) Sector con más tareas completadas en un radio de 2km.
   * @returns {Promise<Object|null>} - SectorCountDTO o null si retorna 204 No Content
   */
  async getTopSector2km() {
    const response = await api.get('/stats/top-sector-2km')
    return response.status === 204 ? null : response.data
  },

  /**
   * 7) Sector con más tareas completadas en un radio de 5km.
   * @returns {Promise<Object|null>} - SectorCountDTO o null si retorna 204 No Content
   */
  async getTopSector5km() {
    const response = await api.get('/stats/top-sector-5km')
    return response.status === 204 ? null : response.data
  },

  /**
   * 2) La tarea más cercana al usuario que esté pendiente.
   * @returns {Promise<Object|null>} - TaskEntity o null si retorna 204 No Content
   */
  async getClosestPendingTask() {
    const response = await api.get('/stats/closest-pending')
    return response.status === 204 ? null : response.data
  },

  /**
   * 4) Promedio de distancia de las tareas completadas respecto al usuario.
   * @returns {Promise<Number>} - Distancia promedio (Double en Java)
   */
  async getAvgDistanceCompleted() {
    const response = await api.get('/stats/avg-distance-completed')
    // Si no hay tareas, el backend podría devolver un valor vacío, aseguramos retornar 0
    return response.data || 0
  },

  /**
   * 4b) Promedio de distancia de las tareas completadas respecto a un punto arbitrario elegido por el usuario.
   * @param {number} latitude
   * @param {number} longitude
   * @returns {Promise<Number>} - Distancia promedio (Double en Java)
   */
  async getAvgDistanceCompletedCustom(latitude, longitude) {
    const response = await api.get('/stats/avg-distance-completed-custom', {
      params: { latitude, longitude },
    })
    return response.data || 0
  },

  /**
   * 5) Sectores donde se concentran tareas pendientes, incluye coordenadas del centroide.
   * @returns {Promise<Array>} - Lista de SectorClusterDTO { sectorName, pendingCount, centroidWkt }
   */
  async getPendingBySectorCluster() {
    const response = await api.get('/stats/pending-by-sector-cluster')
    return response.data || []
  },
}

export default statsService

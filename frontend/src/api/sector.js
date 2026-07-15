import api from './axios.js'

const sectorService = {
  /**
   * Obtiene la lista de todos los sectores.
   * Accesible para cualquier usuario autenticado (sin restricción @PreAuthorize).
   * @returns {Promise<Array>} - Lista de SectorEntity
   */
  async getAllSectors() {
    const response = await api.get('/sectors')
    return response.data
  },

  /**
   * Obtiene un sector específico por su ID.
   * @param {Number} id
   * @returns {Promise<Object>} - SectorEntity
   */
  async getSectorById(id) {
    const response = await api.get(`/sectors/${id}`)
    return response.data
  },

  /**
   * Crea un nuevo sector (Requiere rol ADMIN).
   * @param {Object} sectorData - Datos del sector a crear
   * @returns {Promise<Object>} - SectorEntity creado
   */
  async createSector(sectorData) {
    const response = await api.post('/sectors', sectorData)
    return response.data
  },

  /**
   * Actualiza un sector existente (Requiere rol ADMIN).
   * @param {Number} id
   * @param {Object} sectorData - Datos actualizados
   * @returns {Promise<Object>} - SectorEntity actualizado
   */
  async updateSector(id, sectorData) {
    const response = await api.put(`/sectors/${id}`, sectorData)
    return response.data
  },

  /**
   * Elimina un sector por su ID (Requiere rol ADMIN).
   * @param {Number} id
   * @returns {Promise<void>}
   */
  async deleteSector(id) {
    await api.delete(`/sectors/${id}`)
  },
}

export default sectorService

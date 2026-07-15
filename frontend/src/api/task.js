import api from './axios.js'

const taskService = {
  /**
   * Crea una nueva tarea.
   * @param {Object} taskData - Corresponde a TaskRequestDTO (title, description, dueDate, sectorId, latitude, longitude)
   * @returns {Promise<Object>} - Retorna TaskResponseDTO
   */
  async createTask(taskData) {
    const response = await api.post('/tasks', taskData)
    return response.data
  },

  /**
   * Actualiza una tarea existente en su totalidad.
   * @param {Number} id - ID de la tarea
   * @param {Object} taskData - Corresponde a TaskRequestDTO
   * @returns {Promise<Object>} - Retorna TaskResponseDTO actualizado
   */
  async updateTask(id, taskData) {
    const response = await api.put(`/tasks/${id}`, taskData)
    return response.data
  },

  /**
   * Elimina una tarea.
   * @param {Number} id - ID de la tarea
   * @returns {Promise<void>}
   */
  async deleteTask(id) {
    await api.delete(`/tasks/${id}`)
  },

  /**
   * Marca una tarea como completada.
   * Utiliza PATCH porque es una modificación parcial de la entidad.
   * @param {Number} id - ID de la tarea
   * @returns {Promise<Object>} - Retorna TaskResponseDTO con el status actualizado
   */
  async completeTask(id) {
    // Axios requiere un cuerpo (body) en las peticiones PATCH/PUT/POST.
    // Como el backend no espera un DTO aquí (solo el @PathVariable), enviamos un objeto vacío {}.
    const response = await api.patch(`/tasks/${id}/complete`, {})
    return response.data
  },

  /**
   * Obtiene la lista de tareas del usuario logueado.
   * Permite filtrado opcional por estado y palabra clave.
   * @param {Object} filters - Objeto opcional equivalente a FilterTaskDTO { status, keyword }
   * @returns {Promise<Array>} - Lista de TaskResponseDTO
   */
  async getTasks(filters = {}) {
    // Axios transforma automáticamente la propiedad 'params' en una query string
    // Ejemplo: si filters es { status: 'PENDING' }, la URL será '/tasks?status=PENDING'
    const response = await api.get('/tasks', {
      params: filters,
    })
    return response.data || []
  },
}

export default taskService

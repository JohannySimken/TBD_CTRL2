import api from './axios.js'

const authService = {
  /**
   * Envía las credenciales al backend para iniciar sesión.
   * @param {Object} credentials - Debe contener { username, password } (LoginRequestDTO)
   * @returns {Promise<Object>} - Retorna LoginResponseDTO { token, username, role }
   */
  async login(credentials) {
    const response = await api.post('/auth/login', credentials)
    this._saveSession(response.data)
    return response.data
  },

  /**
   * Registra un nuevo usuario en el sistema.
   * @param {Object} userData - Debe contener { username, email, password, latitude, longitude } (RegisterRequestDTO)
   * @returns {Promise<Object>} - El backend también retorna LoginResponseDTO al registrarse
   */
  async register(userData) {
    const response = await api.post('/auth/register', userData)
    this._saveSession(response.data)
    return response.data
  },

  logout() {
    localStorage.removeItem('loa_token')
    localStorage.removeItem('loa_user')
    window.location.href = '/login'
  },

  /**
   * Método privado utilitario para guardar el token y los datos del usuario.
   * @param {Object} data - Corresponde al LoginResponseDTO de Spring Boot
   */
  _saveSession(data) {
    if (data && data.token) {
      localStorage.setItem('loa_token', data.token)
      localStorage.setItem(
        'loa_user',
        JSON.stringify({
          username: data.username,
          role: data.role,
        }),
      )
    }
  },
}

export default authService

import { createContext, useContext, useState, useEffect } from 'react'
import bcrypt from 'bcryptjs'

const AuthContext = createContext(null)

export function AuthProvider({ children }) {
  const [user, setUser] = useState(() => {
    const stored = localStorage.getItem('roost_user')
    return stored ? JSON.parse(stored) : null
  })

  useEffect(() => {
    if (user) {
      localStorage.setItem('roost_user', JSON.stringify(user))
    } else {
      localStorage.removeItem('roost_user')
    }
  }, [user])

  async function login(email, password) {
    const users = JSON.parse(localStorage.getItem('roost_users') || '[]')
    const found = users.find(u => u.email === email)
    if (!found) return { error: 'Invalid email or password' }

    const isBcrypt = found.password?.startsWith('$2')
    const valid = isBcrypt
      ? await bcrypt.compare(password, found.password)
      : found.password === password

    if (!valid) return { error: 'Invalid email or password' }

    if (!isBcrypt) {
      found.password = await bcrypt.hash(password, 10)
      const allUsers = JSON.parse(localStorage.getItem('roost_users') || '[]')
      const idx = allUsers.findIndex(u => u.email === email)
      if (idx !== -1) allUsers[idx].password = found.password
      localStorage.setItem('roost_users', JSON.stringify(allUsers))
    }

    const { password: _, ...safe } = found
    setUser(safe)
    return { success: true }
  }

  async function register(name, email, password) {
    const users = JSON.parse(localStorage.getItem('roost_users') || '[]')
    if (users.find(u => u.email === email)) {
      return { error: 'An account with this email already exists' }
    }
    const newUser = {
      id: crypto.randomUUID(),
      name,
      email,
      avatar: null,
      preferences: {
        notifications: true,
        priceMin: 0,
        priceMax: 5000000,
        location: 'all',
        propertyType: 'all'
      },
      createdAt: new Date().toISOString()
    }
    const hashedPassword = await bcrypt.hash(password, 10)
    users.push({ ...newUser, password: hashedPassword })
    localStorage.setItem('roost_users', JSON.stringify(users))
    setUser(newUser)
    return { success: true }
  }

  function updateProfile(updates) {
    const updated = { ...user, ...updates }
    setUser(updated)
    const users = JSON.parse(localStorage.getItem('roost_users') || '[]')
    const idx = users.findIndex(u => u.id === user.id)
    if (idx !== -1) {
      users[idx] = { ...users[idx], ...updates }
      localStorage.setItem('roost_users', JSON.stringify(users))
    }
  }

  function logout() {
    setUser(null)
  }

  return (
    <AuthContext.Provider value={{ user, login, register, updateProfile, logout }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  return useContext(AuthContext)
}

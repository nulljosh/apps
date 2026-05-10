import { createContext, useContext, useState, useEffect } from 'react'
import { supabase } from '../lib/supabase.js'

function generatePixelArtSVG() {
  const palettes = [['#e63946','#457b9d','#1d3557'],['#7b2d8b','#c77dff','#e0aaff'],['#0077b6','#00b4d8','#90e0ef'],['#d62828','#f77f00','#fcbf49'],['#2d6a4f','#52b788','#b7e4c7']]
  const bgs = ['#111','#0c1220','#1a1a1a','#0f0f1a','#0a1a0a']
  const palette = palettes[Math.floor(Math.random() * palettes.length)]
  const bg = bgs[Math.floor(Math.random() * bgs.length)]
  const px = 8, size = 8, total = size * px
  const grid = Array.from({ length: size }, () =>
    Array.from({ length: Math.ceil(size / 2) }, () =>
      Math.random() > 0.45 ? Math.floor(Math.random() * 3) : -1))
  let rects = ''
  for (let row = 0; row < size; row++) {
    for (let col = 0; col < size; col++) {
      const ci = grid[row][col < size / 2 ? col : size - 1 - col]
      if (ci >= 0) rects += `<rect x="${col * px}" y="${row * px}" width="${px}" height="${px}" fill="${palette[ci]}"/>`
    }
  }
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${total} ${total}" width="${total}" height="${total}" shape-rendering="crispEdges"><rect width="${total}" height="${total}" fill="${bg}"/>${rects}</svg>`
  return `data:image/svg+xml;base64,${btoa(svg)}`
}

function mapUser(sbUser) {
  if (!sbUser) return null
  const meta = sbUser.user_metadata || {}
  return {
    id: sbUser.id,
    email: sbUser.email,
    name: meta.name || '',
    avatar: meta.avatar || null,
    preferences: meta.preferences || {
      notifications: true,
      priceMin: 0,
      priceMax: 5000000,
      location: 'all',
      propertyType: 'all'
    },
    createdAt: sbUser.created_at
  }
}

const AuthContext = createContext(null)

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null)

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(mapUser(session?.user ?? null))
    })

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(mapUser(session?.user ?? null))
    })

    return () => subscription.unsubscribe()
  }, [])

  async function login(email, password) {
    const { error } = await supabase.auth.signInWithPassword({ email, password })
    if (error) return { error: error.message }
    return { success: true }
  }

  async function register(name, email, password) {
    const { error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: {
          name,
          avatar: generatePixelArtSVG(),
          preferences: {
            notifications: true,
            priceMin: 0,
            priceMax: 5000000,
            location: 'all',
            propertyType: 'all'
          }
        }
      }
    })
    if (error) return { error: error.message }
    return { success: true }
  }

  async function updateProfile(updates) {
    const { name, email, preferences, avatar } = updates
    const data = {}
    if (name !== undefined) data.name = name
    if (preferences !== undefined) data.preferences = preferences
    if (avatar !== undefined) data.avatar = avatar

    const params = { data }
    if (email !== undefined) params.email = email

    const { data: result, error } = await supabase.auth.updateUser(params)
    if (!error && result.user) setUser(mapUser(result.user))
  }

  async function logout() {
    await supabase.auth.signOut()
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

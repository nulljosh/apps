import { Routes, Route, Navigate } from 'react-router-dom'
import { useAuth } from './context/AuthContext'
import Nav from './components/Nav'
import Listings from './pages/Listings'
import ListingDetail from './pages/ListingDetail'
import Login from './pages/Login'
import Register from './pages/Register'
import ForgotPassword from './pages/ForgotPassword'
import Settings from './pages/Settings'

function ProtectedRoute({ children }) {
  const { user } = useAuth()
  if (!user) return <Navigate to="/login" replace />
  return children
}

export default function App() {
  const { user } = useAuth()

  return (
    <div className="app">
      <div className="noise-overlay" />
      {user && <Nav />}
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
        <Route path="/forgot-password" element={<ForgotPassword />} />
        <Route path="/" element={<ProtectedRoute><Listings /></ProtectedRoute>} />
        <Route path="/listing/:id" element={<ProtectedRoute><ListingDetail /></ProtectedRoute>} />
        <Route path="/settings" element={<ProtectedRoute><Settings /></ProtectedRoute>} />
      </Routes>
    </div>
  )
}

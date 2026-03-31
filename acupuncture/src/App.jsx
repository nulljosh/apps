import { Routes, Route } from 'react-router-dom'
import Nav from './components/Nav'
import Home from './pages/Home'
import Feet from './pages/Feet'
import Hands from './pages/Hands'
import Acupuncture from './pages/Acupuncture'
import Symptoms from './pages/Symptoms'
import History from './pages/History'

export default function App() {
  return (
    <div className="app">
      <div className="noise-overlay" />
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/feet" element={<Feet />} />
        <Route path="/hands" element={<Hands />} />
        <Route path="/acupuncture" element={<Acupuncture />} />
        <Route path="/symptoms" element={<Symptoms />} />
        <Route path="/history" element={<History />} />
      </Routes>
      <Nav />
    </div>
  )
}

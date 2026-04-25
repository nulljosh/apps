import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { VitePWA } from 'vite-plugin-pwa'

export default defineConfig({
  plugins: [
    react(),
    VitePWA({
      registerType: 'autoUpdate',
      manifest: {
        name: 'Roost',
        short_name: 'Roost',
        description: 'BC real estate listings',
        theme_color: '#0c1220',
        background_color: '#0c1220',
        display: 'standalone',
        icons: [
          { src: '/icon.svg', sizes: 'any', type: 'image/svg+xml' }
        ]
      }
    })
  ]
})

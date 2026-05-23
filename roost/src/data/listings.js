const neighborhoods = {
  vancouver: [
    { area: 'Kitsilano', lat: 49.2665, lng: -123.1648 },
    { area: 'Mount Pleasant', lat: 49.2620, lng: -123.1005 },
    { area: 'Yaletown', lat: 49.2730, lng: -123.1215 },
    { area: 'Gastown', lat: 49.2838, lng: -123.1089 },
    { area: 'West End', lat: 49.2849, lng: -123.1356 },
    { area: 'Fairview', lat: 49.2635, lng: -123.1295 },
    { area: 'Kerrisdale', lat: 49.2335, lng: -123.1560 },
    { area: 'Dunbar', lat: 49.2505, lng: -123.1870 },
    { area: 'Commercial Drive', lat: 49.2685, lng: -123.0698 },
    { area: 'Coal Harbour', lat: 49.2895, lng: -123.1241 },
    { area: 'South Granville', lat: 49.2525, lng: -123.1385 },
    { area: 'Cambie', lat: 49.2465, lng: -123.1160 },
    { area: 'Riley Park', lat: 49.2440, lng: -123.1020 },
    { area: 'Hastings-Sunrise', lat: 49.2815, lng: -123.0445 },
    { area: 'Marpole', lat: 49.2115, lng: -123.1300 }
  ],
  burnaby: [
    { area: 'Metrotown', lat: 49.2270, lng: -123.0015 },
    { area: 'Brentwood', lat: 49.2665, lng: -123.0015 },
    { area: 'Burnaby Heights', lat: 49.2815, lng: -123.0135 },
    { area: 'Edmonds', lat: 49.2125, lng: -122.9590 }
  ],
  newWest: [
    { area: 'Downtown New West', lat: 49.2015, lng: -122.9128 },
    { area: 'Sapperton', lat: 49.2235, lng: -122.8890 }
  ],
  richmond: [
    { area: 'Richmond Centre', lat: 49.1665, lng: -123.1365 },
    { area: 'Steveston', lat: 49.1280, lng: -123.1870 }
  ],
  northVan: [
    { area: 'Lower Lonsdale', lat: 49.3100, lng: -123.0810 },
    { area: 'Lynn Valley', lat: 49.3385, lng: -123.0215 }
  ],
  victoria: [
    { area: 'James Bay', lat: 48.4115, lng: -123.3675 },
    { area: 'Fernwood', lat: 48.4305, lng: -123.3480 },
    { area: 'Oak Bay', lat: 48.4265, lng: -123.3175 },
    { area: 'Fairfield', lat: 48.4165, lng: -123.3410 }
  ],
  kelowna: [
    { area: 'Downtown Kelowna', lat: 49.8863, lng: -119.4966 },
    { area: 'Mission', lat: 49.8590, lng: -119.4830 },
    { area: 'Rutland', lat: 49.8855, lng: -119.4175 }
  ]
}

const streets = [
  'Oak St', 'Granville St', 'Main St', 'Broadway', 'Cambie St', '4th Ave',
  'Robson St', 'Davie St', 'Hastings St', 'Kingsway', 'Commercial Dr',
  'Fraser St', 'Knight St', 'Victoria Dr', 'Dunbar St', 'Arbutus St',
  'Burrard St', 'Denman St', 'Pacific Blvd', 'Marine Dr', 'King Edward Ave',
  'West 10th Ave', 'West 16th Ave', 'East 1st Ave', 'Clark Dr',
  'Lonsdale Ave', 'Government St', 'Fort St', 'Pandora Ave', 'Douglas St',
  'Bernard Ave', 'Ellis St', 'Harvey Ave', 'Pandosy St', 'Abbott St'
]

const propertyTypes = ['house', 'condo', 'townhouse']

const photos = [
  'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=600&h=400&fit=crop',
  'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=600&h=400&fit=crop',
  'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=600&h=400&fit=crop',
  'https://images.unsplash.com/photo-1600566753086-00f18fb6b3ea?w=600&h=400&fit=crop',
  'https://images.unsplash.com/photo-1600573472591-ee6b68d14c68?w=600&h=400&fit=crop',
  'https://images.unsplash.com/photo-1583608205776-bfd35f0d9f83?w=600&h=400&fit=crop',
  'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=600&h=400&fit=crop',
  'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=600&h=400&fit=crop',
  'https://images.unsplash.com/photo-1576941089067-2de3c901e126?w=600&h=400&fit=crop',
  'https://images.unsplash.com/photo-1598228723793-52759bba239c?w=600&h=400&fit=crop',
  'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=600&h=400&fit=crop',
  'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?w=600&h=400&fit=crop'
]

function seededRandom(seed) {
  let s = seed
  return function() {
    s = (s * 16807 + 0) % 2147483647
    return (s - 1) / 2147483646
  }
}

function generateListings() {
  const allNeighborhoods = Object.values(neighborhoods).flat()
  const rand = seededRandom(42)
  const listings = []

  for (let i = 0; i < 50; i++) {
    const hood = allNeighborhoods[Math.floor(rand() * allNeighborhoods.length)]
    const type = propertyTypes[Math.floor(rand() * propertyTypes.length)]
    const streetNum = Math.floor(rand() * 9000) + 100
    const street = streets[Math.floor(rand() * streets.length)]

    let beds, baths, sqft, price
    if (type === 'house') {
      beds = Math.floor(rand() * 4) + 2
      baths = Math.floor(rand() * 3) + 1
      sqft = Math.floor(rand() * 2000) + 1200
      price = Math.floor((rand() * 3000000 + 800000) / 1000) * 1000
    } else if (type === 'condo') {
      beds = Math.floor(rand() * 3) + 1
      baths = 1
      sqft = Math.floor(rand() * 800) + 450
      price = Math.floor((rand() * 1200000 + 350000) / 1000) * 1000
    } else {
      beds = Math.floor(rand() * 3) + 2
      baths = Math.floor(rand() * 2) + 1
      sqft = Math.floor(rand() * 1200) + 800
      price = Math.floor((rand() * 1500000 + 500000) / 1000) * 1000
    }

    const lat = hood.lat + (rand() - 0.5) * 0.01
    const lng = hood.lng + (rand() - 0.5) * 0.01
    const year = Math.floor(rand() * 60) + 1965
    const daysAgo = Math.floor(rand() * 30) + 1

    listings.push({
      id: `listing-${i + 1}`,
      address: `${streetNum} ${street}`,
      neighborhood: hood.area,
      city: Object.entries(neighborhoods).find(([_, hoods]) =>
        hoods.some(h => h.area === hood.area)
      )?.[0].replace(/([A-Z])/g, ' $1').trim() || 'Vancouver',
      price,
      beds,
      baths,
      sqft,
      type,
      lat,
      lng,
      year,
      photo: photos[i % photos.length],
      photos: [
        photos[i % photos.length],
        photos[(i + 3) % photos.length],
        photos[(i + 7) % photos.length]
      ],
      description: `${type === 'house' ? 'Beautiful' : type === 'condo' ? 'Modern' : 'Spacious'} ${beds}-bedroom ${type} in the heart of ${hood.area}. Built in ${year}, featuring ${sqft} sq ft of living space with ${baths} bathroom${baths > 1 ? 's' : ''}. Walking distance to shops, restaurants, and transit.`,
      features: [
        type === 'house' ? 'Detached garage' : 'Underground parking',
        year > 2010 ? 'Modern finishes' : 'Character home',
        'In-suite laundry',
        sqft > 1500 ? 'Open concept' : 'Efficient layout',
        beds >= 3 ? 'Family-friendly' : 'Low maintenance'
      ],
      listedDaysAgo: daysAgo,
      mlsNumber: `R${2800000 + i}`
    })
  }

  return listings
}

export const listings = generateListings()

export function getListingById(id) {
  return listings.find(l => l.id === id)
}

export function formatPrice(price) {
  if (price >= 1000000) {
    return `$${(price / 1000000).toFixed(price % 1000000 === 0 ? 0 : 1)}M`
  }
  return `$${(price / 1000).toFixed(0)}K`
}

export function formatPriceFull(price) {
  return new Intl.NumberFormat('en-CA', {
    style: 'currency',
    currency: 'CAD',
    maximumFractionDigits: 0
  }).format(price)
}

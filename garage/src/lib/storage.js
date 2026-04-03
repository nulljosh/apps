const PARTS_KEY = 'garage_parts';
const HISTORY_KEY = 'garage_history';

const SEEDED_KEY = 'garage_seeded';

export function getParts() {
  try {
    const stored = JSON.parse(localStorage.getItem(PARTS_KEY));
    if (stored && stored.length > 0) return stored;
    // Seed demo data on first load (only if never seeded before)
    if (!localStorage.getItem(SEEDED_KEY)) {
      localStorage.setItem(SEEDED_KEY, '1');
      saveParts(DEMO_DATA);
      return [...DEMO_DATA];
    }
    return [];
  } catch {
    return [];
  }
}

export function saveParts(parts) {
  localStorage.setItem(PARTS_KEY, JSON.stringify(parts));
}

export function getHistory() {
  try {
    return JSON.parse(localStorage.getItem(HISTORY_KEY)) || [];
  } catch {
    return [];
  }
}

export function addHistory(entry) {
  const history = getHistory();
  history.unshift({ ...entry, timestamp: Date.now() });
  if (history.length > 500) history.length = 500;
  localStorage.setItem(HISTORY_KEY, JSON.stringify(history));
}

export function generateId() {
  return Date.now().toString(36) + Math.random().toString(36).slice(2, 8);
}

export const CATEGORIES = [
  'Springs',
  'Openers',
  'Panels',
  'Hardware',
  'Remotes',
  'Weatherstripping',
  'Rollers',
  'Motors',
  'Tracks',
  'Cables',
  'Seals',
];

export const DEMO_DATA = [
  // Springs (100+ units)
  { id: 'd01', name: 'Torsion Spring 2" ID x 24"', sku: 'SPR-TOR-224', category: 'Springs', quantity: 48, minThreshold: 10, cost: 42.50, supplier: 'Dasma Supply' },
  { id: 'd02', name: 'Torsion Spring 2" ID x 28"', sku: 'SPR-TOR-228', category: 'Springs', quantity: 35, minThreshold: 10, cost: 48.75, supplier: 'Dasma Supply' },
  { id: 'd03', name: 'Torsion Spring 1.75" ID x 22"', sku: 'SPR-TOR-175', category: 'Springs', quantity: 22, minThreshold: 8, cost: 38.00, supplier: 'Dasma Supply' },
  { id: 'd04', name: 'Extension Spring 25" 120lb', sku: 'SPR-EXT-120', category: 'Springs', quantity: 60, minThreshold: 15, cost: 18.50, supplier: 'Prime Line' },
  { id: 'd05', name: 'Extension Spring 25" 150lb', sku: 'SPR-EXT-150', category: 'Springs', quantity: 45, minThreshold: 15, cost: 21.00, supplier: 'Prime Line' },
  { id: 'd06', name: 'Extension Spring 25" 180lb', sku: 'SPR-EXT-180', category: 'Springs', quantity: 30, minThreshold: 10, cost: 24.50, supplier: 'Prime Line' },
  { id: 'd07', name: 'Safety Cable Kit (pair)', sku: 'SPR-SAF-KIT', category: 'Springs', quantity: 40, minThreshold: 12, cost: 14.00, supplier: 'National Hardware' },
  { id: 'd08', name: 'Winding Cone Set', sku: 'SPR-WND-SET', category: 'Springs', quantity: 25, minThreshold: 8, cost: 9.50, supplier: 'Dasma Supply' },

  // Rollers
  { id: 'd09', name: 'Nylon Roller 2" 4" Stem', sku: 'ROL-NYL-204', category: 'Rollers', quantity: 200, minThreshold: 50, cost: 3.25, supplier: 'National Hardware' },
  { id: 'd10', name: 'Nylon Roller 2" 7" Stem', sku: 'ROL-NYL-207', category: 'Rollers', quantity: 150, minThreshold: 40, cost: 3.75, supplier: 'National Hardware' },
  { id: 'd11', name: 'Steel Roller 2" 4" Stem', sku: 'ROL-STL-204', category: 'Rollers', quantity: 120, minThreshold: 30, cost: 2.10, supplier: 'National Hardware' },
  { id: 'd12', name: 'Sealed Bearing Roller 2"', sku: 'ROL-SBR-200', category: 'Rollers', quantity: 80, minThreshold: 20, cost: 5.50, supplier: 'Ideal Door' },
  { id: 'd13', name: 'Ultra-Quiet Nylon Roller 13-ball', sku: 'ROL-UQN-13B', category: 'Rollers', quantity: 60, minThreshold: 15, cost: 8.25, supplier: 'Clopay' },

  // Motors
  { id: 'd14', name: 'Chain Drive Motor 1/2 HP', sku: 'MOT-CHN-050', category: 'Motors', quantity: 8, minThreshold: 3, cost: 189.00, supplier: 'Chamberlain' },
  { id: 'd15', name: 'Chain Drive Motor 3/4 HP', sku: 'MOT-CHN-075', category: 'Motors', quantity: 6, minThreshold: 3, cost: 229.00, supplier: 'Chamberlain' },
  { id: 'd16', name: 'Belt Drive Motor 1/2 HP', sku: 'MOT-BLT-050', category: 'Motors', quantity: 5, minThreshold: 2, cost: 265.00, supplier: 'LiftMaster' },
  { id: 'd17', name: 'Belt Drive Motor 3/4 HP', sku: 'MOT-BLT-075', category: 'Motors', quantity: 4, minThreshold: 2, cost: 315.00, supplier: 'LiftMaster' },
  { id: 'd18', name: 'Screw Drive Motor 3/4 HP', sku: 'MOT-SCR-075', category: 'Motors', quantity: 3, minThreshold: 2, cost: 245.00, supplier: 'Genie' },
  { id: 'd19', name: 'Jackshaft Wall-Mount Motor', sku: 'MOT-JAK-100', category: 'Motors', quantity: 2, minThreshold: 1, cost: 425.00, supplier: 'LiftMaster' },

  // Openers
  { id: 'd20', name: 'LiftMaster 8500W Wall Mount', sku: 'OPN-LFT-8500', category: 'Openers', quantity: 4, minThreshold: 2, cost: 398.00, supplier: 'LiftMaster' },
  { id: 'd21', name: 'Chamberlain B4545T Belt Drive', sku: 'OPN-CHM-4545', category: 'Openers', quantity: 6, minThreshold: 3, cost: 279.00, supplier: 'Chamberlain' },
  { id: 'd22', name: 'Genie ChainMax 1000 Chain Drive', sku: 'OPN-GEN-1000', category: 'Openers', quantity: 5, minThreshold: 2, cost: 198.00, supplier: 'Genie' },
  { id: 'd23', name: 'Linear LDCO800 Chain Drive', sku: 'OPN-LIN-800', category: 'Openers', quantity: 3, minThreshold: 2, cost: 165.00, supplier: 'Linear' },

  // Panels
  { id: 'd24', name: 'Steel Panel 8x7 Raised', sku: 'PNL-STL-8X7R', category: 'Panels', quantity: 12, minThreshold: 4, cost: 145.00, supplier: 'Clopay' },
  { id: 'd25', name: 'Steel Panel 9x7 Raised', sku: 'PNL-STL-9X7R', category: 'Panels', quantity: 10, minThreshold: 4, cost: 165.00, supplier: 'Clopay' },
  { id: 'd26', name: 'Steel Panel 16x7 Raised', sku: 'PNL-STL-167R', category: 'Panels', quantity: 6, minThreshold: 2, cost: 285.00, supplier: 'Clopay' },
  { id: 'd27', name: 'Insulated Panel 8x7 Flush', sku: 'PNL-INS-8X7F', category: 'Panels', quantity: 8, minThreshold: 3, cost: 210.00, supplier: 'Wayne Dalton' },
  { id: 'd28', name: 'Insulated Panel 16x7 Flush', sku: 'PNL-INS-167F', category: 'Panels', quantity: 4, minThreshold: 2, cost: 385.00, supplier: 'Wayne Dalton' },
  { id: 'd29', name: 'Window Insert Panel 24x12', sku: 'PNL-WIN-2412', category: 'Panels', quantity: 18, minThreshold: 6, cost: 45.00, supplier: 'Clopay' },

  // Hardware
  { id: 'd30', name: 'Hinge #1 (bottom)', sku: 'HDW-HNG-001', category: 'Hardware', quantity: 100, minThreshold: 25, cost: 4.50, supplier: 'National Hardware' },
  { id: 'd31', name: 'Hinge #2 (middle)', sku: 'HDW-HNG-002', category: 'Hardware', quantity: 85, minThreshold: 25, cost: 4.50, supplier: 'National Hardware' },
  { id: 'd32', name: 'Hinge #3 (top)', sku: 'HDW-HNG-003', category: 'Hardware', quantity: 90, minThreshold: 25, cost: 5.00, supplier: 'National Hardware' },
  { id: 'd33', name: 'End Bearing Plate (left)', sku: 'HDW-EBP-LFT', category: 'Hardware', quantity: 20, minThreshold: 6, cost: 18.50, supplier: 'Dasma Supply' },
  { id: 'd34', name: 'End Bearing Plate (right)', sku: 'HDW-EBP-RGT', category: 'Hardware', quantity: 20, minThreshold: 6, cost: 18.50, supplier: 'Dasma Supply' },
  { id: 'd35', name: 'Center Bearing Bracket', sku: 'HDW-CBB-STD', category: 'Hardware', quantity: 30, minThreshold: 8, cost: 12.00, supplier: 'Dasma Supply' },
  { id: 'd36', name: 'Strut 8ft Horizontal', sku: 'HDW-STR-8FT', category: 'Hardware', quantity: 15, minThreshold: 5, cost: 32.00, supplier: 'National Hardware' },
  { id: 'd37', name: 'Strut 16ft Horizontal', sku: 'HDW-STR-16F', category: 'Hardware', quantity: 8, minThreshold: 3, cost: 58.00, supplier: 'National Hardware' },
  { id: 'd38', name: 'Bracket Flag (pair)', sku: 'HDW-BKT-FLG', category: 'Hardware', quantity: 45, minThreshold: 12, cost: 7.25, supplier: 'Prime Line' },
  { id: 'd39', name: 'Lock T-Handle Kit', sku: 'HDW-LCK-THK', category: 'Hardware', quantity: 25, minThreshold: 8, cost: 15.00, supplier: 'Prime Line' },

  // Remotes
  { id: 'd40', name: 'LiftMaster 893LM 3-Button', sku: 'RMT-LFT-893', category: 'Remotes', quantity: 30, minThreshold: 10, cost: 32.00, supplier: 'LiftMaster' },
  { id: 'd41', name: 'LiftMaster 890MAX Mini', sku: 'RMT-LFT-890', category: 'Remotes', quantity: 25, minThreshold: 8, cost: 24.00, supplier: 'LiftMaster' },
  { id: 'd42', name: 'Chamberlain 953EV 3-Button', sku: 'RMT-CHM-953', category: 'Remotes', quantity: 20, minThreshold: 8, cost: 28.00, supplier: 'Chamberlain' },
  { id: 'd43', name: 'Genie G3T-R 3-Button', sku: 'RMT-GEN-G3T', category: 'Remotes', quantity: 15, minThreshold: 5, cost: 26.00, supplier: 'Genie' },
  { id: 'd44', name: 'Universal Remote 4-Button', sku: 'RMT-UNI-004', category: 'Remotes', quantity: 35, minThreshold: 10, cost: 18.00, supplier: 'Clicker' },
  { id: 'd45', name: 'Keypad Wireless Entry', sku: 'RMT-KPD-WLS', category: 'Remotes', quantity: 12, minThreshold: 4, cost: 38.00, supplier: 'LiftMaster' },

  // Weatherstripping
  { id: 'd46', name: 'Bottom Seal T-End 8ft', sku: 'WTR-BTM-T08', category: 'Weatherstripping', quantity: 40, minThreshold: 10, cost: 12.50, supplier: 'Frost King' },
  { id: 'd47', name: 'Bottom Seal T-End 16ft', sku: 'WTR-BTM-T16', category: 'Weatherstripping', quantity: 25, minThreshold: 8, cost: 22.00, supplier: 'Frost King' },
  { id: 'd48', name: 'Side Seal PVC 7ft (pair)', sku: 'WTR-SDE-PVC', category: 'Weatherstripping', quantity: 30, minThreshold: 10, cost: 16.00, supplier: 'M-D Building' },
  { id: 'd49', name: 'Top Seal Vinyl 8ft', sku: 'WTR-TOP-V08', category: 'Weatherstripping', quantity: 20, minThreshold: 6, cost: 11.00, supplier: 'M-D Building' },
  { id: 'd50', name: 'Top Seal Vinyl 16ft', sku: 'WTR-TOP-V16', category: 'Weatherstripping', quantity: 15, minThreshold: 5, cost: 19.00, supplier: 'M-D Building' },
  { id: 'd51', name: 'Threshold Seal 10ft', sku: 'WTR-THR-010', category: 'Weatherstripping', quantity: 18, minThreshold: 5, cost: 35.00, supplier: 'Tsunami Seal' },

  // Tracks
  { id: 'd52', name: 'Vertical Track 7ft (pair)', sku: 'TRK-VRT-07P', category: 'Tracks', quantity: 14, minThreshold: 4, cost: 42.00, supplier: 'Dasma Supply' },
  { id: 'd53', name: 'Horizontal Track 8ft', sku: 'TRK-HRZ-08', category: 'Tracks', quantity: 12, minThreshold: 4, cost: 38.00, supplier: 'Dasma Supply' },
  { id: 'd54', name: 'Horizontal Track 12ft', sku: 'TRK-HRZ-12', category: 'Tracks', quantity: 8, minThreshold: 3, cost: 52.00, supplier: 'Dasma Supply' },
  { id: 'd55', name: 'Curved Track Section', sku: 'TRK-CRV-STD', category: 'Tracks', quantity: 10, minThreshold: 4, cost: 28.00, supplier: 'National Hardware' },
  { id: 'd56', name: 'Low Headroom Track Kit', sku: 'TRK-LHR-KIT', category: 'Tracks', quantity: 5, minThreshold: 2, cost: 85.00, supplier: 'Dasma Supply' },

  // Cables
  { id: 'd57', name: 'Lift Cable 1/8" 8ft (pair)', sku: 'CBL-LFT-808', category: 'Cables', quantity: 35, minThreshold: 10, cost: 14.00, supplier: 'National Hardware' },
  { id: 'd58', name: 'Lift Cable 1/8" 12ft (pair)', sku: 'CBL-LFT-812', category: 'Cables', quantity: 25, minThreshold: 8, cost: 18.00, supplier: 'National Hardware' },
  { id: 'd59', name: 'Lift Cable 3/32" 8ft (pair)', sku: 'CBL-LFT-308', category: 'Cables', quantity: 20, minThreshold: 6, cost: 12.00, supplier: 'Prime Line' },
  { id: 'd60', name: 'Cable Drum Standard', sku: 'CBL-DRM-STD', category: 'Cables', quantity: 30, minThreshold: 8, cost: 16.50, supplier: 'Dasma Supply' },
  { id: 'd61', name: 'Cable Drum Hi-Lift', sku: 'CBL-DRM-HLF', category: 'Cables', quantity: 10, minThreshold: 3, cost: 24.00, supplier: 'Dasma Supply' },

  // Seals
  { id: 'd62', name: 'Panel-to-Panel Seal 8ft', sku: 'SEL-PTP-008', category: 'Seals', quantity: 30, minThreshold: 8, cost: 8.50, supplier: 'M-D Building' },
  { id: 'd63', name: 'Panel-to-Panel Seal 16ft', sku: 'SEL-PTP-016', category: 'Seals', quantity: 20, minThreshold: 6, cost: 15.00, supplier: 'M-D Building' },
  { id: 'd64', name: 'Astragal Retainer 8ft', sku: 'SEL-AST-008', category: 'Seals', quantity: 22, minThreshold: 6, cost: 6.00, supplier: 'Frost King' },
  { id: 'd65', name: 'Brush Seal 10ft Roll', sku: 'SEL-BRS-010', category: 'Seals', quantity: 12, minThreshold: 4, cost: 28.00, supplier: 'Frost King' },

  // More Hardware (fasteners, misc)
  { id: 'd66', name: 'Lag Bolt 3/8x3" (50pk)', sku: 'HDW-LAG-383', category: 'Hardware', quantity: 40, minThreshold: 10, cost: 18.00, supplier: 'National Hardware' },
  { id: 'd67', name: 'Nylon Spacer Kit', sku: 'HDW-NSP-KIT', category: 'Hardware', quantity: 50, minThreshold: 15, cost: 6.00, supplier: 'Prime Line' },
  { id: 'd68', name: 'Spring Anchor Bracket', sku: 'HDW-SAB-STD', category: 'Hardware', quantity: 18, minThreshold: 5, cost: 14.00, supplier: 'Dasma Supply' },

  // Low stock items (for alert testing)
  { id: 'd69', name: 'Photo Eye Safety Sensor (pair)', sku: 'HDW-PES-PAR', category: 'Hardware', quantity: 2, minThreshold: 4, cost: 42.00, supplier: 'LiftMaster' },
  { id: 'd70', name: 'Torsion Spring 2.5" ID x 32"', sku: 'SPR-TOR-253', category: 'Springs', quantity: 1, minThreshold: 3, cost: 68.00, supplier: 'Dasma Supply' },
  { id: 'd71', name: 'Belt Drive Replacement Belt', sku: 'MOT-BLT-RPL', category: 'Motors', quantity: 1, minThreshold: 2, cost: 45.00, supplier: 'Chamberlain' },
  { id: 'd72', name: 'Insulated Panel 9x7 Carriage', sku: 'PNL-INS-9CR', category: 'Panels', quantity: 0, minThreshold: 2, cost: 320.00, supplier: 'Wayne Dalton' },
];

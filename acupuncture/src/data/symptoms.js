export const symptoms = [
  {
    id: 'headache',
    name: 'Headache',
    icon: 'M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z',
    reflexZones: ['brain', 'sinuses', 'spine', 'solar-plexus'],
    acuPoints: ['LI-4', 'GB-20', 'GV-20', 'LR-3', 'ST-44'],
    selfCare: 'Apply firm pressure to LI-4 (Hegu) between thumb and index finger for 2-3 minutes. Follow with GB-20 at the base of the skull. For reflexology, work the big toe tips and the inner edge (spine reflex).'
  },
  {
    id: 'back-pain',
    name: 'Back Pain',
    icon: 'M12 2L4 7v10l8 5 8-5V7l-8-5zm0 2.18l6 3.75v7.14l-6 3.75-6-3.75V7.93l6-3.75z',
    reflexZones: ['spine', 'sciatic', 'kidneys', 'shoulder'],
    acuPoints: ['GB-34', 'KI-3', 'GV-26', 'SP-6'],
    selfCare: 'Work the entire inner arch of the foot (spine reflex) with thumb-walking. For acupressure, press GB-34 below the fibula head and KI-3 behind the inner ankle. Hold each point 1-2 minutes.'
  },
  {
    id: 'insomnia',
    name: 'Insomnia',
    icon: 'M12 3a9 9 0 109 9c0-4.97-4.03-9-9-9zm0 16a7 7 0 010-14 7 7 0 010 14zm1-11h-2v5l4.28 2.54.72-1.21-3-1.78V8z',
    reflexZones: ['brain', 'solar-plexus', 'kidneys', 'thyroid'],
    acuPoints: ['HT-7', 'SP-6', 'KI-1', 'GV-20', 'PC-6'],
    selfCare: 'Press HT-7 (Shenmen) on the inner wrist crease for 2 minutes each hand before bed. Press KI-1 on the sole of each foot. Work the solar plexus reflex in the center of each foot with deep, slow pressure.'
  },
  {
    id: 'stress',
    name: 'Stress & Anxiety',
    icon: 'M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z',
    reflexZones: ['solar-plexus', 'brain', 'thyroid', 'heart'],
    acuPoints: ['HT-7', 'PC-6', 'LR-3', 'GV-20', 'LI-4'],
    selfCare: 'Start with the solar plexus reflex: press deep into the center of each foot and hold for 10 seconds, release, repeat 5 times. Then press LR-3 between the 1st and 2nd toe. Finish with HT-7 on each wrist.'
  },
  {
    id: 'digestive',
    name: 'Digestive Issues',
    icon: 'M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z',
    reflexZones: ['stomach', 'intestines', 'liver', 'solar-plexus'],
    acuPoints: ['ST-36', 'ST-25', 'CV-12', 'SP-6', 'PC-6'],
    selfCare: 'Press ST-36 (Zusanli) below the knee for 2-3 minutes each leg -- the premier digestive point. For reflexology, thumb-walk the entire arch area covering stomach, intestines, and liver reflexes. Work CV-12 above the navel with gentle clockwise circles.'
  },
  {
    id: 'nausea',
    name: 'Nausea',
    icon: 'M12 8l-6 6 1.41 1.41L12 10.83l4.59 4.58L18 14z',
    reflexZones: ['stomach', 'solar-plexus', 'intestines'],
    acuPoints: ['PC-6', 'ST-36', 'CV-12'],
    selfCare: 'PC-6 (Neiguan) is the single most effective anti-nausea point. Press between the two tendons on the inner forearm, 2 cun above the wrist crease. Hold for 2-3 minutes. This is the point targeted by acupressure wristbands.'
  },
  {
    id: 'neck-shoulder',
    name: 'Neck & Shoulder Pain',
    icon: 'M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3z',
    reflexZones: ['shoulder', 'spine', 'brain'],
    acuPoints: ['GB-20', 'GB-21', 'LI-4', 'LU-7'],
    selfCare: 'Press GB-20 at the base of the skull on both sides, angling pressure toward the opposite eye. Follow with GB-21 at the top of the shoulder. For reflexology, work the shoulder reflex on the outer edge of each foot below the little toe.'
  },
  {
    id: 'fatigue',
    name: 'Fatigue & Low Energy',
    icon: 'M7 2v11h3v9l7-12h-4l4-8z',
    reflexZones: ['kidneys', 'thyroid', 'solar-plexus', 'brain'],
    acuPoints: ['ST-36', 'CV-6', 'CV-4', 'KI-3', 'GV-20'],
    selfCare: 'ST-36 (Zusanli) is traditionally called the "longevity point" -- press firmly for 3 minutes each leg. Follow with CV-6 (Sea of Qi) below the navel with warm palm pressure. Work the kidney reflex in the center arch of each foot.'
  },
  {
    id: 'sinus',
    name: 'Sinus Congestion',
    icon: 'M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z',
    reflexZones: ['sinuses', 'lungs', 'eyes'],
    acuPoints: ['LI-20', 'LI-4', 'LU-7', 'GB-20'],
    selfCare: 'Press LI-20 (Yingxiang) beside each nostril for immediate relief. Add LI-4 between thumb and index finger. For reflexology, squeeze and roll each toe (sinus reflexes) for 30 seconds each. Work the lung reflex across the ball of each foot.'
  },
  {
    id: 'menstrual',
    name: 'Menstrual Pain',
    icon: 'M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z',
    reflexZones: ['bladder', 'kidneys', 'intestines', 'solar-plexus'],
    acuPoints: ['SP-6', 'SP-10', 'LR-3', 'CV-4', 'ST-36'],
    selfCare: 'SP-6 (Sanyinjiao) is the key point -- press 3 cun above the inner ankle for 2-3 minutes each leg. Add LR-3 between the 1st and 2nd toe. Work the lower foot reflexes for reproductive and urinary systems. AVOID SP-6 and LI-4 during pregnancy.'
  },
  {
    id: 'eye-strain',
    name: 'Eye Strain',
    icon: 'M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5z',
    reflexZones: ['eyes', 'brain', 'kidneys'],
    acuPoints: ['GB-20', 'LR-3', 'LI-4'],
    selfCare: 'Press the eye reflex at the base of the 2nd and 3rd toes on each foot. For acupressure, use GB-20 at the skull base and LR-3 on the foot (liver opens to the eyes in TCM). Also press gently around the orbital bone with fingertips.'
  },
  {
    id: 'knee-pain',
    name: 'Knee Pain',
    icon: 'M12 2L4 7v10l8 5 8-5V7l-8-5z',
    reflexZones: ['sciatic', 'spine', 'kidneys'],
    acuPoints: ['GB-34', 'SP-9', 'SP-10', 'ST-36'],
    selfCare: 'GB-34 (Yanglingquan) below the fibula head is the master point for tendons and ligaments. Press SP-9 on the inner knee and ST-36 below the knee. For reflexology, work the sciatic and musculoskeletal zones on the heel and lower foot.'
  }
]

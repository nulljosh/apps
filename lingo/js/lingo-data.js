// Categories and subjects
const categories = {
    languages: {
        title: 'Choose a language',
        subjects: [
            { id: 'spanish', name: 'Spanish', icon: 'fa-solid fa-earth-americas', level: 'Beginner to Advanced' },
            { id: 'french', name: 'French', icon: 'fa-solid fa-earth-europe', level: 'Beginner to Advanced' },
            { id: 'german', name: 'German', icon: 'fa-solid fa-language', level: 'Beginner to Intermediate' },
            { id: 'italian', name: 'Italian', icon: 'fa-solid fa-pizza-slice', level: 'Beginner to Intermediate' },
            { id: 'portuguese', name: 'Portuguese', icon: 'fa-solid fa-earth-americas', level: 'Beginner' },
            { id: 'japanese', name: 'Japanese', icon: 'fa-solid fa-earth-asia', level: 'Beginner' },
            { id: 'chinese', name: 'Chinese', icon: 'fa-solid fa-earth-asia', level: 'Beginner' },
            { id: 'korean', name: 'Korean', icon: 'fa-solid fa-earth-asia', level: 'Beginner' },
            { id: 'russian', name: 'Russian', icon: 'fa-solid fa-earth-europe', level: 'Beginner' },
            { id: 'arabic', name: 'Arabic', icon: 'fa-solid fa-earth-africa', level: 'Beginner' },
            { id: 'hindi', name: 'Hindi', icon: 'fa-solid fa-earth-asia', level: 'Beginner' },
            { id: 'dutch', name: 'Dutch', icon: 'fa-solid fa-earth-europe', level: 'Beginner' }
        ]
    },
    programming: {
        title: 'Choose a programming language',
        subjects: [
            { id: 'javascript', name: 'JavaScript', icon: 'fa-brands fa-js', level: 'Web Development' },
            { id: 'python', name: 'Python', icon: 'fa-brands fa-python', level: 'General Purpose' },
            { id: 'rust', name: 'Rust', icon: 'fa-brands fa-rust', level: 'Systems Programming' },
            { id: 'cpp', name: 'C++', icon: 'fa-solid fa-microchip', level: 'Systems & Games' },
            { id: 'java', name: 'Java', icon: 'fa-brands fa-java', level: 'Enterprise & Android' },
            { id: 'go', name: 'Go', icon: 'fa-brands fa-golang', level: 'Cloud & DevOps' },
            { id: 'sql', name: 'SQL', icon: 'fa-solid fa-database', level: 'Database Queries' }
        ]
    },
    math: {
        title: 'Choose a math topic',
        subjects: [
            { id: 'arithmetic', name: 'Arithmetic', icon: 'fa-solid fa-plus', level: 'Basic Math' },
            { id: 'algebra', name: 'Algebra', icon: 'fa-solid fa-superscript', level: 'Equations & Variables' },
            { id: 'geometry', name: 'Geometry', icon: 'fa-solid fa-draw-polygon', level: 'Shapes & Angles' },
            { id: 'trigonometry', name: 'Trigonometry', icon: 'fa-solid fa-wave-square', level: 'Sine, Cosine, Tangent' },
            { id: 'calculus', name: 'Calculus', icon: 'fa-solid fa-infinity', level: 'Derivatives & Integrals' },
            { id: 'statistics', name: 'Statistics', icon: 'fa-solid fa-chart-bar', level: 'Data Analysis' },
            { id: 'linear_algebra', name: 'Linear Algebra', icon: 'fa-solid fa-table-cells', level: 'Matrices & Vectors' },
            { id: 'logic', name: 'Logic', icon: 'fa-solid fa-puzzle-piece', level: 'Puzzles & Reasoning' }
        ]
    },
    science: {
        title: 'Choose a science topic',
        subjects: [
            { id: 'physics', name: 'Physics', icon: 'fa-solid fa-atom', level: 'Forces & Energy' },
            { id: 'chemistry', name: 'Chemistry', icon: 'fa-solid fa-flask', level: 'Elements & Reactions' },
            { id: 'biology', name: 'Biology', icon: 'fa-solid fa-dna', level: 'Life Sciences' },
            { id: 'astronomy', name: 'Astronomy', icon: 'fa-solid fa-satellite', level: 'Space & Cosmos' }
        ]
    },
    skills: {
        title: 'Choose a skill',
        subjects: [
            { id: 'chess', name: 'Chess', icon: 'fa-solid fa-chess', level: 'Strategy & Tactics' },
            { id: 'music_theory', name: 'Music Theory', icon: 'fa-solid fa-music', level: 'Notes & Chords' },
            { id: 'music_history', name: 'Music History', icon: 'fa-solid fa-guitar', level: 'Genres & Artists' },
            { id: 'world_history', name: 'World History', icon: 'fa-solid fa-landmark', level: 'Events & Civilizations' },
            { id: 'geography', name: 'Geography', icon: 'fa-solid fa-globe', level: 'Countries & Capitals' }
        ]
    }
};

// Questions database
const questions = {

    // ========== LANGUAGES ==========

    spanish: [
        // Original 5
        { type: 'translation', question: 'Hello', answer: 'Hola', choices: ['Hola', 'Adios', 'Por favor', 'Gracias'] },
        { type: 'translation', question: 'Thank you', answer: 'Gracias', choices: ['Hola', 'Gracias', 'De nada', 'Por favor'] },
        { type: 'sentence', question: 'The cat is small', answer: 'El gato es pequeno', words: ['El', 'gato', 'es', 'pequeno', 'grande', 'perro'] },
        { type: 'translation', question: 'Water', answer: 'Agua', choices: ['Agua', 'Fuego', 'Tierra', 'Aire'] },
        { type: 'sentence', question: 'I like coffee', answer: 'Me gusta el cafe', words: ['Me', 'gusta', 'el', 'cafe', 'te', 'no'] },
        // 5 new translation
        { type: 'translation', question: 'Goodbye', answer: 'Adios', choices: ['Adios', 'Hola', 'Buenas', 'Salud'] },
        { type: 'translation', question: 'Please', answer: 'Por favor', choices: ['Por favor', 'Gracias', 'De nada', 'Lo siento'] },
        { type: 'translation', question: 'House', answer: 'Casa', choices: ['Casa', 'Carro', 'Cama', 'Calle'] },
        { type: 'translation', question: 'Dog', answer: 'Perro', choices: ['Gato', 'Perro', 'Pajaro', 'Pez'] },
        { type: 'translation', question: 'Book', answer: 'Libro', choices: ['Libro', 'Libra', 'Litro', 'Listo'] },
        // 3 new sentence
        { type: 'sentence', question: 'The dog is big', answer: 'El perro es grande', words: ['El', 'perro', 'es', 'grande', 'pequeno', 'gato'] },
        { type: 'sentence', question: 'I want water', answer: 'Yo quiero agua', words: ['Yo', 'quiero', 'agua', 'cafe', 'tengo', 'el'] },
        { type: 'sentence', question: 'She eats bread', answer: 'Ella come pan', words: ['Ella', 'come', 'pan', 'El', 'bebe', 'leche'] },
        // 2 new listening
        { type: 'listening', question: 'Type what you hear', audio: 'Buenos dias', answer: 'Buenos dias' },
        { type: 'listening', question: 'Type what you hear', audio: 'Lo siento', answer: 'Lo siento' }
    ],

    french: [
        // Original 2
        { type: 'translation', question: 'Hello', answer: 'Bonjour', choices: ['Bonjour', 'Au revoir', 'Merci', 'Bonsoir'] },
        { type: 'translation', question: 'Thank you', answer: 'Merci', choices: ['Merci', 'De rien', 'Bonjour', 'Bonne nuit'] },
        // 6 new translation
        { type: 'translation', question: 'Goodbye', answer: 'Au revoir', choices: ['Au revoir', 'Bonjour', 'Bonsoir', 'Salut'] },
        { type: 'translation', question: 'Water', answer: 'Eau', choices: ['Eau', 'Feu', 'Air', 'Terre'] },
        { type: 'translation', question: 'Cat', answer: 'Chat', choices: ['Chat', 'Chien', 'Cheval', 'Cochon'] },
        { type: 'translation', question: 'House', answer: 'Maison', choices: ['Maison', 'Jardin', 'Chambre', 'Cuisine'] },
        { type: 'translation', question: 'Please', answer: "S'il vous plait", choices: ["S'il vous plait", 'Merci', 'De rien', 'Pardon'] },
        { type: 'translation', question: 'Yes', answer: 'Oui', choices: ['Oui', 'Non', 'Peut-etre', 'Jamais'] },
        // 4 new sentence
        { type: 'sentence', question: 'The cat is black', answer: 'Le chat est noir', words: ['Le', 'chat', 'est', 'noir', 'blanc', 'chien'] },
        { type: 'sentence', question: 'I eat bread', answer: 'Je mange du pain', words: ['Je', 'mange', 'du', 'pain', 'bois', 'lait'] },
        { type: 'sentence', question: 'She is beautiful', answer: 'Elle est belle', words: ['Elle', 'est', 'belle', 'Il', 'grand', 'petit'] },
        { type: 'sentence', question: 'I like music', answer: 'J\'aime la musique', words: ["J'aime", 'la', 'musique', 'le', 'film', 'deteste'] },
        // 3 new listening
        { type: 'listening', question: 'Type what you hear', audio: 'Bonjour', answer: 'Bonjour' },
        { type: 'listening', question: 'Type what you hear', audio: 'Comment allez-vous', answer: 'Comment allez-vous' },
        { type: 'listening', question: 'Type what you hear', audio: 'Bonne nuit', answer: 'Bonne nuit' }
    ],

    german: [
        // 8 translation
        { type: 'translation', question: 'Hello', answer: 'Hallo', choices: ['Hallo', 'Danke', 'Bitte', 'Tschuss'] },
        { type: 'translation', question: 'Thank you', answer: 'Danke', choices: ['Danke', 'Bitte', 'Hallo', 'Ja'] },
        { type: 'translation', question: 'Goodbye', answer: 'Tschuss', choices: ['Tschuss', 'Hallo', 'Danke', 'Nein'] },
        { type: 'translation', question: 'Water', answer: 'Wasser', choices: ['Wasser', 'Feuer', 'Luft', 'Erde'] },
        { type: 'translation', question: 'Dog', answer: 'Hund', choices: ['Hund', 'Katze', 'Vogel', 'Fisch'] },
        { type: 'translation', question: 'House', answer: 'Haus', choices: ['Haus', 'Auto', 'Baum', 'Buch'] },
        { type: 'translation', question: 'Good morning', answer: 'Guten Morgen', choices: ['Guten Morgen', 'Guten Tag', 'Guten Abend', 'Gute Nacht'] },
        { type: 'translation', question: 'Please', answer: 'Bitte', choices: ['Bitte', 'Danke', 'Ja', 'Nein'] },
        // 4 sentence
        { type: 'sentence', question: 'The dog is big', answer: 'Der Hund ist gross', words: ['Der', 'Hund', 'ist', 'gross', 'klein', 'Katze'] },
        { type: 'sentence', question: 'I drink water', answer: 'Ich trinke Wasser', words: ['Ich', 'trinke', 'Wasser', 'esse', 'Brot', 'Du'] },
        { type: 'sentence', question: 'She is nice', answer: 'Sie ist nett', words: ['Sie', 'ist', 'nett', 'Er', 'gross', 'schnell'] },
        { type: 'sentence', question: 'The book is good', answer: 'Das Buch ist gut', words: ['Das', 'Buch', 'ist', 'gut', 'schlecht', 'Der'] },
        // 3 listening
        { type: 'listening', question: 'Type what you hear', audio: 'Guten Tag', answer: 'Guten Tag' },
        { type: 'listening', question: 'Type what you hear', audio: 'Ich liebe dich', answer: 'Ich liebe dich' },
        { type: 'listening', question: 'Type what you hear', audio: 'Entschuldigung', answer: 'Entschuldigung' }
    ],

    italian: [
        // 8 translation
        { type: 'translation', question: 'Hello', answer: 'Ciao', choices: ['Ciao', 'Grazie', 'Prego', 'Scusa'] },
        { type: 'translation', question: 'Thank you', answer: 'Grazie', choices: ['Grazie', 'Ciao', 'Prego', 'Buono'] },
        { type: 'translation', question: 'Goodbye', answer: 'Arrivederci', choices: ['Arrivederci', 'Ciao', 'Buongiorno', 'Grazie'] },
        { type: 'translation', question: 'Water', answer: 'Acqua', choices: ['Acqua', 'Fuoco', 'Aria', 'Terra'] },
        { type: 'translation', question: 'Good morning', answer: 'Buongiorno', choices: ['Buongiorno', 'Buonanotte', 'Buonasera', 'Ciao'] },
        { type: 'translation', question: 'Cat', answer: 'Gatto', choices: ['Gatto', 'Cane', 'Uccello', 'Pesce'] },
        { type: 'translation', question: 'House', answer: 'Casa', choices: ['Casa', 'Porta', 'Strada', 'Cucina'] },
        { type: 'translation', question: 'Please', answer: 'Per favore', choices: ['Per favore', 'Grazie', 'Prego', 'Scusa'] },
        // 4 sentence
        { type: 'sentence', question: 'The cat is small', answer: 'Il gatto e piccolo', words: ['Il', 'gatto', 'e', 'piccolo', 'grande', 'cane'] },
        { type: 'sentence', question: 'I eat pizza', answer: 'Io mangio la pizza', words: ['Io', 'mangio', 'la', 'pizza', 'bevo', 'acqua'] },
        { type: 'sentence', question: 'The book is good', answer: 'Il libro e buono', words: ['Il', 'libro', 'e', 'buono', 'cattivo', 'La'] },
        { type: 'sentence', question: 'She speaks Italian', answer: 'Lei parla italiano', words: ['Lei', 'parla', 'italiano', 'Lui', 'inglese', 'scrive'] },
        // 3 listening
        { type: 'listening', question: 'Type what you hear', audio: 'Buongiorno', answer: 'Buongiorno' },
        { type: 'listening', question: 'Type what you hear', audio: 'Come stai', answer: 'Come stai' },
        { type: 'listening', question: 'Type what you hear', audio: 'Mi chiamo Marco', answer: 'Mi chiamo Marco' }
    ],

    portuguese: [
        // 8 translation
        { type: 'translation', question: 'Hello', answer: 'Ola', choices: ['Ola', 'Tchau', 'Obrigado', 'Por favor'] },
        { type: 'translation', question: 'Thank you', answer: 'Obrigado', choices: ['Obrigado', 'Ola', 'Tchau', 'Desculpa'] },
        { type: 'translation', question: 'Goodbye', answer: 'Tchau', choices: ['Tchau', 'Ola', 'Bom dia', 'Obrigado'] },
        { type: 'translation', question: 'Water', answer: 'Agua', choices: ['Agua', 'Fogo', 'Ar', 'Terra'] },
        { type: 'translation', question: 'Dog', answer: 'Cachorro', choices: ['Cachorro', 'Gato', 'Passaro', 'Peixe'] },
        { type: 'translation', question: 'Good morning', answer: 'Bom dia', choices: ['Bom dia', 'Boa noite', 'Boa tarde', 'Ola'] },
        { type: 'translation', question: 'House', answer: 'Casa', choices: ['Casa', 'Rua', 'Carro', 'Porta'] },
        { type: 'translation', question: 'Please', answer: 'Por favor', choices: ['Por favor', 'Obrigado', 'Desculpa', 'Sim'] },
        // 4 sentence
        { type: 'sentence', question: 'The dog is big', answer: 'O cachorro e grande', words: ['O', 'cachorro', 'e', 'grande', 'pequeno', 'gato'] },
        { type: 'sentence', question: 'I drink coffee', answer: 'Eu bebo cafe', words: ['Eu', 'bebo', 'cafe', 'como', 'agua', 'Ela'] },
        { type: 'sentence', question: 'She is pretty', answer: 'Ela e bonita', words: ['Ela', 'e', 'bonita', 'Ele', 'alto', 'feio'] },
        { type: 'sentence', question: 'The book is good', answer: 'O livro e bom', words: ['O', 'livro', 'e', 'bom', 'ruim', 'A'] },
        // 3 listening
        { type: 'listening', question: 'Type what you hear', audio: 'Bom dia', answer: 'Bom dia' },
        { type: 'listening', question: 'Type what you hear', audio: 'Como vai voce', answer: 'Como vai voce' },
        { type: 'listening', question: 'Type what you hear', audio: 'Boa noite', answer: 'Boa noite' }
    ],

    japanese: [
        // 8 translation (romanized)
        { type: 'translation', question: 'Hello', answer: 'Konnichiwa', choices: ['Konnichiwa', 'Sayounara', 'Arigatou', 'Sumimasen'] },
        { type: 'translation', question: 'Thank you', answer: 'Arigatou', choices: ['Arigatou', 'Konnichiwa', 'Gomen', 'Hai'] },
        { type: 'translation', question: 'Goodbye', answer: 'Sayounara', choices: ['Sayounara', 'Konnichiwa', 'Ohayou', 'Arigatou'] },
        { type: 'translation', question: 'Good morning', answer: 'Ohayou gozaimasu', choices: ['Ohayou gozaimasu', 'Konbanwa', 'Konnichiwa', 'Oyasumi'] },
        { type: 'translation', question: 'Water', answer: 'Mizu', choices: ['Mizu', 'Hi', 'Kaze', 'Tsuchi'] },
        { type: 'translation', question: 'Cat', answer: 'Neko', choices: ['Neko', 'Inu', 'Tori', 'Sakana'] },
        { type: 'translation', question: 'Dog', answer: 'Inu', choices: ['Inu', 'Neko', 'Uma', 'Usagi'] },
        { type: 'translation', question: 'Yes', answer: 'Hai', choices: ['Hai', 'Iie', 'Tabun', 'Chotto'] },
        // 4 sentence
        { type: 'sentence', question: 'I am a student', answer: 'Watashi wa gakusei desu', words: ['Watashi', 'wa', 'gakusei', 'desu', 'sensei', 'anata'] },
        { type: 'sentence', question: 'This is a book', answer: 'Kore wa hon desu', words: ['Kore', 'wa', 'hon', 'desu', 'pen', 'Sore'] },
        { type: 'sentence', question: 'I like sushi', answer: 'Watashi wa sushi ga suki desu', words: ['Watashi', 'wa', 'sushi', 'ga', 'suki', 'desu', 'kirai', 'ramen'] },
        { type: 'sentence', question: 'The cat is cute', answer: 'Neko wa kawaii desu', words: ['Neko', 'wa', 'kawaii', 'desu', 'Inu', 'ookii'] },
        // 3 listening
        { type: 'listening', question: 'Type what you hear', audio: 'Konnichiwa', answer: 'Konnichiwa' },
        { type: 'listening', question: 'Type what you hear', audio: 'Arigatou gozaimasu', answer: 'Arigatou gozaimasu' },
        { type: 'listening', question: 'Type what you hear', audio: 'Sumimasen', answer: 'Sumimasen' }
    ],

    chinese: [
        // 8 translation (romanized pinyin)
        { type: 'translation', question: 'Hello', answer: 'Ni hao', choices: ['Ni hao', 'Zaijian', 'Xiexie', 'Duibuqi'] },
        { type: 'translation', question: 'Thank you', answer: 'Xiexie', choices: ['Xiexie', 'Ni hao', 'Zaijian', 'Buke qi'] },
        { type: 'translation', question: 'Goodbye', answer: 'Zaijian', choices: ['Zaijian', 'Ni hao', 'Xiexie', 'Wanan'] },
        { type: 'translation', question: 'Water', answer: 'Shui', choices: ['Shui', 'Huo', 'Feng', 'Tu'] },
        { type: 'translation', question: 'Good morning', answer: 'Zao shang hao', choices: ['Zao shang hao', 'Wan shang hao', 'Xiawu hao', 'Ni hao'] },
        { type: 'translation', question: 'Cat', answer: 'Mao', choices: ['Mao', 'Gou', 'Niao', 'Yu'] },
        { type: 'translation', question: 'Dog', answer: 'Gou', choices: ['Gou', 'Mao', 'Ma', 'Niu'] },
        { type: 'translation', question: 'Yes', answer: 'Shi', choices: ['Shi', 'Bu shi', 'Mei you', 'Keyi'] },
        // 4 sentence
        { type: 'sentence', question: 'I am Chinese', answer: 'Wo shi Zhongguo ren', words: ['Wo', 'shi', 'Zhongguo', 'ren', 'Meiguo', 'ta'] },
        { type: 'sentence', question: 'I like tea', answer: 'Wo xihuan cha', words: ['Wo', 'xihuan', 'cha', 'kafei', 'bu', 'he'] },
        { type: 'sentence', question: 'This is a book', answer: 'Zhe shi yi ben shu', words: ['Zhe', 'shi', 'yi', 'ben', 'shu', 'na', 'bi', 'ge'] },
        { type: 'sentence', question: 'She is a teacher', answer: 'Ta shi laoshi', words: ['Ta', 'shi', 'laoshi', 'xuesheng', 'Wo', 'bu'] },
        // 3 listening
        { type: 'listening', question: 'Type what you hear', audio: 'Ni hao', answer: 'Ni hao' },
        { type: 'listening', question: 'Type what you hear', audio: 'Xiexie ni', answer: 'Xiexie ni' },
        { type: 'listening', question: 'Type what you hear', audio: 'Zao shang hao', answer: 'Zao shang hao' }
    ],

    korean: [
        // 8 translation (romanized)
        { type: 'translation', question: 'Hello', answer: 'Annyeonghaseyo', choices: ['Annyeonghaseyo', 'Kamsahamnida', 'Annyeong', 'Mianhamnida'] },
        { type: 'translation', question: 'Thank you', answer: 'Kamsahamnida', choices: ['Kamsahamnida', 'Annyeonghaseyo', 'Mianhamnida', 'Ne'] },
        { type: 'translation', question: 'Goodbye', answer: 'Annyeonghi gaseyo', choices: ['Annyeonghi gaseyo', 'Annyeonghaseyo', 'Kamsahamnida', 'Jalga'] },
        { type: 'translation', question: 'Water', answer: 'Mul', choices: ['Mul', 'Bul', 'Baram', 'Heuk'] },
        { type: 'translation', question: 'Yes', answer: 'Ne', choices: ['Ne', 'Aniyo', 'Keurae', 'Molla'] },
        { type: 'translation', question: 'Cat', answer: 'Goyangi', choices: ['Goyangi', 'Gae', 'Sae', 'Mulgogi'] },
        { type: 'translation', question: 'Dog', answer: 'Gae', choices: ['Gae', 'Goyangi', 'Mal', 'So'] },
        { type: 'translation', question: 'Sorry', answer: 'Mianhamnida', choices: ['Mianhamnida', 'Kamsahamnida', 'Annyeonghaseyo', 'Ne'] },
        // 4 sentence
        { type: 'sentence', question: 'I am a student', answer: 'Jeo neun haksaeng imnida', words: ['Jeo', 'neun', 'haksaeng', 'imnida', 'seonsaengnim', 'geu'] },
        { type: 'sentence', question: 'I like Korea', answer: 'Jeo neun Hanguk eul joahamnida', words: ['Jeo', 'neun', 'Hanguk', 'eul', 'joahamnida', 'Miguk', 'sireohamnida', 'ga'] },
        { type: 'sentence', question: 'This is delicious', answer: 'Igeo neun masisseoyo', words: ['Igeo', 'neun', 'masisseoyo', 'Geugeo', 'eobseoyo', 'aniyeyo'] },
        { type: 'sentence', question: 'Where is the bathroom', answer: 'Hwajangsil eodi yeyo', words: ['Hwajangsil', 'eodi', 'yeyo', 'mwo', 'sigdang', 'isseoyo'] },
        // 3 listening
        { type: 'listening', question: 'Type what you hear', audio: 'Annyeonghaseyo', answer: 'Annyeonghaseyo' },
        { type: 'listening', question: 'Type what you hear', audio: 'Kamsahamnida', answer: 'Kamsahamnida' },
        { type: 'listening', question: 'Type what you hear', audio: 'Annyeonghi gaseyo', answer: 'Annyeonghi gaseyo' }
    ],

    russian: [
        // 8 translation (romanized)
        { type: 'translation', question: 'Hello', answer: 'Privet', choices: ['Privet', 'Spasibo', 'Do svidaniya', 'Pozhaluysta'] },
        { type: 'translation', question: 'Thank you', answer: 'Spasibo', choices: ['Spasibo', 'Privet', 'Da', 'Izvinite'] },
        { type: 'translation', question: 'Goodbye', answer: 'Do svidaniya', choices: ['Do svidaniya', 'Privet', 'Spasibo', 'Poka'] },
        { type: 'translation', question: 'Water', answer: 'Voda', choices: ['Voda', 'Ogon', 'Vozdukh', 'Zemlya'] },
        { type: 'translation', question: 'Yes', answer: 'Da', choices: ['Da', 'Net', 'Mozhet byt', 'Nikogda'] },
        { type: 'translation', question: 'Cat', answer: 'Koshka', choices: ['Koshka', 'Sobaka', 'Ptitsa', 'Ryba'] },
        { type: 'translation', question: 'Good morning', answer: 'Dobroye utro', choices: ['Dobroye utro', 'Dobryy vecher', 'Spokoynoy nochi', 'Privet'] },
        { type: 'translation', question: 'Please', answer: 'Pozhaluysta', choices: ['Pozhaluysta', 'Spasibo', 'Izvinite', 'Da'] },
        // 4 sentence
        { type: 'sentence', question: 'I am a student', answer: 'Ya student', words: ['Ya', 'student', 'uchitel', 'On', 'ona', 'est'] },
        { type: 'sentence', question: 'The cat is small', answer: 'Koshka malenkaya', words: ['Koshka', 'malenkaya', 'bolshaya', 'Sobaka', 'krasivaya', 'est'] },
        { type: 'sentence', question: 'I like tea', answer: 'Mne nravitsya chay', words: ['Mne', 'nravitsya', 'chay', 'kofe', 'ne', 'voda'] },
        { type: 'sentence', question: 'This is a book', answer: 'Eto kniga', words: ['Eto', 'kniga', 'ruchka', 'To', 'moya', 'est'] },
        // 3 listening
        { type: 'listening', question: 'Type what you hear', audio: 'Privet', answer: 'Privet' },
        { type: 'listening', question: 'Type what you hear', audio: 'Spasibo bolshoye', answer: 'Spasibo bolshoye' },
        { type: 'listening', question: 'Type what you hear', audio: 'Dobroye utro', answer: 'Dobroye utro' }
    ],

    arabic: [
        // 8 translation (romanized)
        { type: 'translation', question: 'Hello', answer: 'Marhaba', choices: ['Marhaba', 'Shukran', 'Ma\'a salama', 'Min fadlak'] },
        { type: 'translation', question: 'Thank you', answer: 'Shukran', choices: ['Shukran', 'Marhaba', 'Afwan', 'Na\'am'] },
        { type: 'translation', question: 'Goodbye', answer: 'Ma\'a salama', choices: ['Ma\'a salama', 'Marhaba', 'Shukran', 'Sabah al-khayr'] },
        { type: 'translation', question: 'Water', answer: 'Maa', choices: ['Maa', 'Nar', 'Hawa', 'Turab'] },
        { type: 'translation', question: 'Yes', answer: 'Na\'am', choices: ['Na\'am', 'La', 'Rubbama', 'Abadan'] },
        { type: 'translation', question: 'Good morning', answer: 'Sabah al-khayr', choices: ['Sabah al-khayr', 'Masa al-khayr', 'Marhaba', 'Tisbah ala khayr'] },
        { type: 'translation', question: 'Cat', answer: 'Qitta', choices: ['Qitta', 'Kalb', 'Tayr', 'Samaka'] },
        { type: 'translation', question: 'Book', answer: 'Kitab', choices: ['Kitab', 'Qalam', 'Bayt', 'Bab'] },
        // 4 sentence
        { type: 'sentence', question: 'I am a student', answer: 'Ana talib', words: ['Ana', 'talib', 'mudarris', 'Huwa', 'Hiya', 'fi'] },
        { type: 'sentence', question: 'The house is big', answer: 'Al-bayt kabir', words: ['Al-bayt', 'kabir', 'saghir', 'Al-kitab', 'jamil', 'fi'] },
        { type: 'sentence', question: 'I like coffee', answer: 'Ana uhibbu al-qahwa', words: ['Ana', 'uhibbu', 'al-qahwa', 'al-shay', 'la', 'Anta'] },
        { type: 'sentence', question: 'This is a book', answer: 'Hadha kitab', words: ['Hadha', 'kitab', 'qalam', 'Hadhihi', 'kabir', 'fi'] },
        // 3 listening
        { type: 'listening', question: 'Type what you hear', audio: 'Marhaba', answer: 'Marhaba' },
        { type: 'listening', question: 'Type what you hear', audio: 'Shukran jazilan', answer: 'Shukran jazilan' },
        { type: 'listening', question: 'Type what you hear', audio: 'Sabah al-khayr', answer: 'Sabah al-khayr' }
    ],

    hindi: [
        // 8 translation (romanized)
        { type: 'translation', question: 'Hello', answer: 'Namaste', choices: ['Namaste', 'Dhanyavaad', 'Alvida', 'Kripaya'] },
        { type: 'translation', question: 'Thank you', answer: 'Dhanyavaad', choices: ['Dhanyavaad', 'Namaste', 'Haan', 'Maaf kijiye'] },
        { type: 'translation', question: 'Goodbye', answer: 'Alvida', choices: ['Alvida', 'Namaste', 'Dhanyavaad', 'Shubh ratri'] },
        { type: 'translation', question: 'Water', answer: 'Paani', choices: ['Paani', 'Aag', 'Hawa', 'Mitti'] },
        { type: 'translation', question: 'Yes', answer: 'Haan', choices: ['Haan', 'Nahin', 'Shayad', 'Kabhi nahin'] },
        { type: 'translation', question: 'Good morning', answer: 'Suprabhat', choices: ['Suprabhat', 'Shubh ratri', 'Namaste', 'Shubh sandhya'] },
        { type: 'translation', question: 'Cat', answer: 'Billi', choices: ['Billi', 'Kutta', 'Pakshi', 'Machhli'] },
        { type: 'translation', question: 'Book', answer: 'Kitab', choices: ['Kitab', 'Kalam', 'Ghar', 'Darwaza'] },
        // 4 sentence
        { type: 'sentence', question: 'I am a student', answer: 'Main ek vidyarthi hoon', words: ['Main', 'ek', 'vidyarthi', 'hoon', 'adhyapak', 'Woh'] },
        { type: 'sentence', question: 'The house is big', answer: 'Ghar bada hai', words: ['Ghar', 'bada', 'hai', 'chhota', 'Kitab', 'mein'] },
        { type: 'sentence', question: 'I like tea', answer: 'Mujhe chai pasand hai', words: ['Mujhe', 'chai', 'pasand', 'hai', 'coffee', 'nahin'] },
        { type: 'sentence', question: 'She is beautiful', answer: 'Woh sundar hai', words: ['Woh', 'sundar', 'hai', 'Main', 'lamba', 'nahin'] },
        // 3 listening
        { type: 'listening', question: 'Type what you hear', audio: 'Namaste', answer: 'Namaste' },
        { type: 'listening', question: 'Type what you hear', audio: 'Aap kaise hain', answer: 'Aap kaise hain' },
        { type: 'listening', question: 'Type what you hear', audio: 'Dhanyavaad', answer: 'Dhanyavaad' }
    ],

    dutch: [
        // 8 translation
        { type: 'translation', question: 'Hello', answer: 'Hallo', choices: ['Hallo', 'Dank u', 'Tot ziens', 'Alsjeblieft'] },
        { type: 'translation', question: 'Thank you', answer: 'Dank u', choices: ['Dank u', 'Hallo', 'Ja', 'Sorry'] },
        { type: 'translation', question: 'Goodbye', answer: 'Tot ziens', choices: ['Tot ziens', 'Hallo', 'Dank u', 'Goedemorgen'] },
        { type: 'translation', question: 'Water', answer: 'Water', choices: ['Water', 'Vuur', 'Lucht', 'Aarde'] },
        { type: 'translation', question: 'Good morning', answer: 'Goedemorgen', choices: ['Goedemorgen', 'Goedenavond', 'Goedenacht', 'Hallo'] },
        { type: 'translation', question: 'Cat', answer: 'Kat', choices: ['Kat', 'Hond', 'Vogel', 'Vis'] },
        { type: 'translation', question: 'Dog', answer: 'Hond', choices: ['Hond', 'Kat', 'Paard', 'Konijn'] },
        { type: 'translation', question: 'Please', answer: 'Alsjeblieft', choices: ['Alsjeblieft', 'Dank u', 'Sorry', 'Ja'] },
        // 4 sentence
        { type: 'sentence', question: 'The cat is small', answer: 'De kat is klein', words: ['De', 'kat', 'is', 'klein', 'groot', 'hond'] },
        { type: 'sentence', question: 'I drink coffee', answer: 'Ik drink koffie', words: ['Ik', 'drink', 'koffie', 'eet', 'thee', 'Hij'] },
        { type: 'sentence', question: 'The book is good', answer: 'Het boek is goed', words: ['Het', 'boek', 'is', 'goed', 'slecht', 'De'] },
        { type: 'sentence', question: 'She is nice', answer: 'Zij is aardig', words: ['Zij', 'is', 'aardig', 'Hij', 'groot', 'snel'] },
        // 3 listening
        { type: 'listening', question: 'Type what you hear', audio: 'Goedemorgen', answer: 'Goedemorgen' },
        { type: 'listening', question: 'Type what you hear', audio: 'Hoe gaat het', answer: 'Hoe gaat het' },
        { type: 'listening', question: 'Type what you hear', audio: 'Tot ziens', answer: 'Tot ziens' }
    ],

    // ========== PROGRAMMING ==========

    javascript: [
        // Original 5
        { type: 'mathChoice', question: 'Log to console in JavaScript?', answer: 'console.log()', choices: ['print()', 'console.log()', 'echo()', 'printf()'] },
        { type: 'mathChoice', question: 'Define a function in JS?', answer: 'function name() {}', choices: ['function name() {}', 'def name():', 'func name() {}', 'fn name() {}'] },
        { type: 'mathChoice', question: 'JavaScript array method to add item?', answer: 'push()', choices: ['add()', 'push()', 'append()', 'insert()'] },
        { type: 'mathChoice', question: 'Check type in JavaScript?', answer: 'typeof', choices: ['type()', 'typeof', 'instanceof', 'getType()'] },
        { type: 'mathChoice', question: 'Arrow function syntax?', answer: '() => {}', choices: ['() => {}', '() -> {}', 'lambda() {}', 'func() {}'] },
        // 10 new
        { type: 'mathChoice', question: 'Declare a constant in JS?', answer: 'const', choices: ['const', 'let', 'var', 'final'] },
        { type: 'mathChoice', question: 'Which is NOT a JS data type?', answer: 'float', choices: ['string', 'boolean', 'float', 'undefined'] },
        { type: 'mathChoice', question: 'Template literal syntax?', answer: '`Hello ${name}`', choices: ['`Hello ${name}`', '"Hello ${name}"', "'Hello ${name}'", 'f"Hello {name}"'] },
        { type: 'mathChoice', question: 'Strict equality operator?', answer: '===', choices: ['===', '==', '!=', '='] },
        { type: 'mathChoice', question: 'Destructure an object?', answer: 'const { a, b } = obj', choices: ['const { a, b } = obj', 'const [a, b] = obj', 'const (a, b) = obj', 'const a, b = obj'] },
        { type: 'mathChoice', question: 'Promise method for parallel execution?', answer: 'Promise.all()', choices: ['Promise.all()', 'Promise.race()', 'Promise.any()', 'Promise.resolve()'] },
        { type: 'mathChoice', question: 'Which keyword creates a class?', answer: 'class', choices: ['class', 'struct', 'object', 'type'] },
        { type: 'mathChoice', question: 'Spread operator syntax?', answer: '...array', choices: ['...array', '**array', '*array', '..array'] },
        { type: 'mathChoice', question: 'Event loop handles what?', answer: 'Async callbacks', choices: ['Async callbacks', 'Memory allocation', 'Garbage collection', 'Compilation'] },
        { type: 'mathChoice', question: 'Optional chaining operator?', answer: '?.', choices: ['?.', '??', '?:', '?.()'] }
    ],

    python: [
        // Original 5
        { type: 'mathChoice', question: 'Import library in Python?', answer: 'import', choices: ['include', 'import', 'require', 'use'] },
        { type: 'mathChoice', question: 'Python list comprehension syntax?', answer: '[x for x in list]', choices: ['[x for x in list]', '{x for x in list}', '(x for x in list)', '<x for x in list>'] },
        { type: 'mathChoice', question: 'Define function in Python?', answer: 'def function_name():', choices: ['def function_name():', 'function function_name():', 'fn function_name():', 'func function_name():'] },
        { type: 'mathChoice', question: 'Python indentation?', answer: '4 spaces', choices: ['2 spaces', '4 spaces', '1 tab', 'No standard'] },
        { type: 'mathChoice', question: 'Python package manager?', answer: 'pip', choices: ['npm', 'pip', 'yarn', 'gem'] },
        // 10 new
        { type: 'mathChoice', question: 'Create a dictionary?', answer: '{"key": "value"}', choices: ['{"key": "value"}', '["key": "value"]', '("key": "value")', '<"key": "value">'] },
        { type: 'mathChoice', question: 'Python ternary operator?', answer: 'x if condition else y', choices: ['x if condition else y', 'condition ? x : y', 'if condition then x else y', 'x when condition else y'] },
        { type: 'mathChoice', question: 'Open a file for reading?', answer: 'open("file", "r")', choices: ['open("file", "r")', 'file.open("r")', 'read("file")', 'File.new("file")'] },
        { type: 'mathChoice', question: 'Python decorator syntax?', answer: '@decorator', choices: ['@decorator', '#decorator', '!decorator', '$decorator'] },
        { type: 'mathChoice', question: 'Create a virtual environment?', answer: 'python -m venv env', choices: ['python -m venv env', 'pip install venv', 'virtualenv --create', 'python --venv env'] },
        { type: 'mathChoice', question: 'Which is immutable?', answer: 'tuple', choices: ['list', 'dict', 'tuple', 'set'] },
        { type: 'mathChoice', question: 'String formatting with f-strings?', answer: 'f"Hello {name}"', choices: ['f"Hello {name}"', '"Hello %s" % name', '"Hello " + name', 'format("Hello", name)'] },
        { type: 'mathChoice', question: 'Handle exceptions?', answer: 'try/except', choices: ['try/except', 'try/catch', 'try/handle', 'begin/rescue'] },
        { type: 'mathChoice', question: 'Lambda function syntax?', answer: 'lambda x: x + 1', choices: ['lambda x: x + 1', '(x) => x + 1', 'fn(x) = x + 1', 'def lambda(x): x + 1'] },
        { type: 'mathChoice', question: 'Check if key exists in dict?', answer: '"key" in dict', choices: ['"key" in dict', 'dict.has("key")', 'dict.contains("key")', 'dict.exists("key")'] }
    ],

    rust: [
        // Original 5
        { type: 'mathChoice', question: 'Rust package manager?', answer: 'cargo', choices: ['cargo', 'rustc', 'crate', 'rust-pm'] },
        { type: 'mathChoice', question: 'Define variable in Rust?', answer: 'let', choices: ['let', 'var', 'const', 'def'] },
        { type: 'mathChoice', question: 'Mutable variable in Rust?', answer: 'let mut', choices: ['let mut', 'var', 'mut let', 'mutable'] },
        { type: 'mathChoice', question: 'Result type in Rust?', answer: 'Ok/Err', choices: ['Ok/Err', 'Success/Fail', 'True/False', 'Some/None'] },
        { type: 'mathChoice', question: 'Rust memory safety?', answer: 'Compile-time', choices: ['Compile-time', 'Runtime', 'Manual', 'Garbage collected'] },
        // 10 new
        { type: 'mathChoice', question: 'Print to stdout in Rust?', answer: 'println!()', choices: ['println!()', 'print()', 'console.log()', 'echo()'] },
        { type: 'mathChoice', question: 'Rust string type for owned data?', answer: 'String', choices: ['String', '&str', 'str', 'Str'] },
        { type: 'mathChoice', question: 'Ownership rule: how many owners?', answer: 'One', choices: ['One', 'Two', 'Unlimited', 'None'] },
        { type: 'mathChoice', question: 'Pattern matching keyword?', answer: 'match', choices: ['match', 'switch', 'case', 'when'] },
        { type: 'mathChoice', question: 'Define a struct?', answer: 'struct Name {}', choices: ['struct Name {}', 'class Name {}', 'type Name {}', 'object Name {}'] },
        { type: 'mathChoice', question: 'Trait is similar to?', answer: 'Interface', choices: ['Interface', 'Class', 'Module', 'Package'] },
        { type: 'mathChoice', question: 'Immutable borrow syntax?', answer: '&value', choices: ['&value', '*value', 'ref value', '@value'] },
        { type: 'mathChoice', question: 'Option type variants?', answer: 'Some/None', choices: ['Some/None', 'Ok/Err', 'True/False', 'Just/Nothing'] },
        { type: 'mathChoice', question: 'Rust loop keyword for infinite loop?', answer: 'loop', choices: ['loop', 'while true', 'for ever', 'repeat'] },
        { type: 'mathChoice', question: 'Cargo command to compile + run?', answer: 'cargo run', choices: ['cargo run', 'cargo build', 'cargo exec', 'cargo start'] }
    ],

    cpp: [
        { type: 'mathChoice', question: 'C++ output statement?', answer: 'std::cout', choices: ['std::cout', 'print()', 'printf()', 'System.out'] },
        { type: 'mathChoice', question: 'Include header syntax?', answer: '#include <iostream>', choices: ['#include <iostream>', 'import iostream', 'using iostream', 'require iostream'] },
        { type: 'mathChoice', question: 'Pointer declaration?', answer: 'int* ptr', choices: ['int* ptr', 'ptr int', 'int &ptr', 'pointer<int> ptr'] },
        { type: 'mathChoice', question: 'Dynamic memory allocation?', answer: 'new', choices: ['new', 'malloc', 'alloc', 'create'] },
        { type: 'mathChoice', question: 'C++ string type?', answer: 'std::string', choices: ['std::string', 'String', 'string', 'char[]'] },
        { type: 'mathChoice', question: 'Reference parameter syntax?', answer: 'void func(int& x)', choices: ['void func(int& x)', 'void func(int* x)', 'void func(ref int x)', 'void func(int x&)'] },
        { type: 'mathChoice', question: 'Standard container for dynamic array?', answer: 'std::vector', choices: ['std::vector', 'std::array', 'std::list', 'std::deque'] },
        { type: 'mathChoice', question: 'Virtual function purpose?', answer: 'Runtime polymorphism', choices: ['Runtime polymorphism', 'Compile-time optimization', 'Memory management', 'Thread safety'] },
        { type: 'mathChoice', question: 'Smart pointer that has unique ownership?', answer: 'unique_ptr', choices: ['unique_ptr', 'shared_ptr', 'weak_ptr', 'auto_ptr'] },
        { type: 'mathChoice', question: 'Namespace access operator?', answer: '::', choices: ['::', '.', '->', '=>'] },
        { type: 'mathChoice', question: 'C++ lambda syntax?', answer: '[](int x) { return x; }', choices: ['[](int x) { return x; }', '(x) => x', 'lambda x: x', 'fn(x) -> x'] },
        { type: 'mathChoice', question: 'Range-based for loop?', answer: 'for (auto x : vec)', choices: ['for (auto x : vec)', 'for x in vec', 'foreach (x in vec)', 'for (x of vec)'] },
        { type: 'mathChoice', question: 'C++ access modifier default in class?', answer: 'private', choices: ['private', 'public', 'protected', 'internal'] },
        { type: 'mathChoice', question: 'Template syntax?', answer: 'template<typename T>', choices: ['template<typename T>', 'generic<T>', '<T> template', 'type T template'] },
        { type: 'mathChoice', question: 'Multiple inheritance supported?', answer: 'Yes', choices: ['Yes', 'No', 'Only interfaces', 'Only abstract classes'] }
    ],

    java: [
        { type: 'mathChoice', question: 'Java entry point method?', answer: 'public static void main(String[] args)', choices: ['public static void main(String[] args)', 'def main():', 'int main()', 'func main()'] },
        { type: 'mathChoice', question: 'Print to console in Java?', answer: 'System.out.println()', choices: ['System.out.println()', 'console.log()', 'print()', 'cout <<'] },
        { type: 'mathChoice', question: 'Java is compiled to?', answer: 'Bytecode', choices: ['Bytecode', 'Machine code', 'JavaScript', 'Assembly'] },
        { type: 'mathChoice', question: 'Keyword for inheritance?', answer: 'extends', choices: ['extends', 'inherits', 'implements', 'derives'] },
        { type: 'mathChoice', question: 'Interface keyword?', answer: 'implements', choices: ['implements', 'extends', 'uses', 'interface'] },
        { type: 'mathChoice', question: 'Java runs on?', answer: 'JVM', choices: ['JVM', 'CLR', 'V8', 'LLVM'] },
        { type: 'mathChoice', question: 'Immutable string alternative?', answer: 'StringBuilder', choices: ['StringBuilder', 'StringBuffer', 'MutableString', 'CharArray'] },
        { type: 'mathChoice', question: 'Java collection for key-value pairs?', answer: 'HashMap', choices: ['HashMap', 'ArrayList', 'LinkedList', 'TreeSet'] },
        { type: 'mathChoice', question: 'Handle exceptions in Java?', answer: 'try/catch', choices: ['try/catch', 'try/except', 'begin/rescue', 'try/handle'] },
        { type: 'mathChoice', question: 'Access modifier for subclass access?', answer: 'protected', choices: ['protected', 'private', 'public', 'default'] },
        { type: 'mathChoice', question: 'Java generics syntax?', answer: 'List<String>', choices: ['List<String>', 'List[String]', 'List(String)', 'List{String}'] },
        { type: 'mathChoice', question: 'Java 8 lambda syntax?', answer: '(x) -> x + 1', choices: ['(x) -> x + 1', '(x) => x + 1', 'lambda x: x + 1', '[](x) { x + 1 }'] },
        { type: 'mathChoice', question: 'Final keyword prevents?', answer: 'Modification/override', choices: ['Modification/override', 'Compilation', 'Instantiation', 'Importing'] },
        { type: 'mathChoice', question: 'Abstract class can be instantiated?', answer: 'No', choices: ['No', 'Yes', 'Only with factory', 'Only in subclass'] },
        { type: 'mathChoice', question: 'Java package manager?', answer: 'Maven/Gradle', choices: ['Maven/Gradle', 'npm', 'pip', 'cargo'] }
    ],

    go: [
        { type: 'mathChoice', question: 'Go entry point function?', answer: 'func main()', choices: ['func main()', 'def main():', 'int main()', 'function main()'] },
        { type: 'mathChoice', question: 'Print in Go?', answer: 'fmt.Println()', choices: ['fmt.Println()', 'print()', 'console.log()', 'System.out.println()'] },
        { type: 'mathChoice', question: 'Declare a variable in Go?', answer: 'var x int', choices: ['var x int', 'int x', 'let x: int', 'x := int'] },
        { type: 'mathChoice', question: 'Short variable declaration?', answer: ':=', choices: [':=', '=', '==', '->'] },
        { type: 'mathChoice', question: 'Go concurrency primitive?', answer: 'goroutine', choices: ['goroutine', 'thread', 'async', 'coroutine'] },
        { type: 'mathChoice', question: 'Channel communication keyword?', answer: 'chan', choices: ['chan', 'channel', 'pipe', 'stream'] },
        { type: 'mathChoice', question: 'Error handling pattern in Go?', answer: 'if err != nil', choices: ['if err != nil', 'try/catch', 'try/except', 'Result<T, E>'] },
        { type: 'mathChoice', question: 'Go has classes?', answer: 'No, only structs', choices: ['No, only structs', 'Yes', 'Only interfaces', 'Only traits'] },
        { type: 'mathChoice', question: 'Multiple return values?', answer: 'Yes, natively', choices: ['Yes, natively', 'No', 'Only with tuples', 'Only with arrays'] },
        { type: 'mathChoice', question: 'Go build tool?', answer: 'go build', choices: ['go build', 'make', 'cargo build', 'gcc'] },
        { type: 'mathChoice', question: 'Go slice vs array?', answer: 'Slice is dynamic', choices: ['Slice is dynamic', 'Array is dynamic', 'Both are fixed', 'No difference'] },
        { type: 'mathChoice', question: 'Defer statement executes when?', answer: 'When function returns', choices: ['When function returns', 'Immediately', 'Never', 'At program exit'] },
        { type: 'mathChoice', question: 'Exported names start with?', answer: 'Uppercase letter', choices: ['Uppercase letter', 'Lowercase letter', 'Underscore', 'pub keyword'] },
        { type: 'mathChoice', question: 'Go module file?', answer: 'go.mod', choices: ['go.mod', 'package.json', 'Cargo.toml', 'pom.xml'] },
        { type: 'mathChoice', question: 'Interface satisfaction in Go?', answer: 'Implicit', choices: ['Implicit', 'Explicit with implements', 'Explicit with extends', 'Not supported'] }
    ],

    sql: [
        { type: 'mathChoice', question: 'Select all columns?', answer: 'SELECT *', choices: ['SELECT *', 'SELECT ALL', 'GET *', 'FETCH ALL'] },
        { type: 'mathChoice', question: 'Filter rows?', answer: 'WHERE', choices: ['WHERE', 'FILTER', 'HAVING', 'IF'] },
        { type: 'mathChoice', question: 'Sort results?', answer: 'ORDER BY', choices: ['ORDER BY', 'SORT BY', 'GROUP BY', 'ARRANGE BY'] },
        { type: 'mathChoice', question: 'Count rows in a table?', answer: 'COUNT(*)', choices: ['COUNT(*)', 'SUM(*)', 'TOTAL(*)', 'NUM(*)'] },
        { type: 'mathChoice', question: 'Join two tables?', answer: 'JOIN ... ON', choices: ['JOIN ... ON', 'MERGE ... WITH', 'COMBINE ... WHERE', 'LINK ... TO'] },
        { type: 'mathChoice', question: 'Remove duplicate rows?', answer: 'SELECT DISTINCT', choices: ['SELECT DISTINCT', 'SELECT UNIQUE', 'SELECT NODUP', 'SELECT SINGLE'] },
        { type: 'mathChoice', question: 'Group aggregate results?', answer: 'GROUP BY', choices: ['GROUP BY', 'ORDER BY', 'SORT BY', 'COLLECT BY'] },
        { type: 'mathChoice', question: 'Filter groups after aggregation?', answer: 'HAVING', choices: ['HAVING', 'WHERE', 'FILTER', 'WHEN'] },
        { type: 'mathChoice', question: 'Insert a row?', answer: 'INSERT INTO ... VALUES', choices: ['INSERT INTO ... VALUES', 'ADD TO ... VALUES', 'PUT INTO ... VALUES', 'CREATE ROW ...'] },
        { type: 'mathChoice', question: 'Update existing data?', answer: 'UPDATE ... SET', choices: ['UPDATE ... SET', 'MODIFY ... SET', 'CHANGE ... TO', 'ALTER ... SET'] },
        { type: 'mathChoice', question: 'Delete rows?', answer: 'DELETE FROM', choices: ['DELETE FROM', 'REMOVE FROM', 'DROP FROM', 'ERASE FROM'] },
        { type: 'mathChoice', question: 'Create a new table?', answer: 'CREATE TABLE', choices: ['CREATE TABLE', 'NEW TABLE', 'MAKE TABLE', 'ADD TABLE'] },
        { type: 'mathChoice', question: 'NULL check syntax?', answer: 'IS NULL', choices: ['IS NULL', '== NULL', '= NULL', 'EQUALS NULL'] },
        { type: 'mathChoice', question: 'Limit number of results?', answer: 'LIMIT', choices: ['LIMIT', 'TOP', 'MAX', 'FIRST'] },
        { type: 'mathChoice', question: 'Subquery returns one value?', answer: 'Scalar subquery', choices: ['Scalar subquery', 'Table subquery', 'Correlated subquery', 'Nested query'] }
    ],

    // ========== MATH ==========

    arithmetic: [
        // Original 5
        { type: 'math', question: '5 + 7', answer: '12' },
        { type: 'math', question: '15 - 8', answer: '7' },
        { type: 'math', question: '6 x 9', answer: '54' },
        { type: 'math', question: '72 / 8', answer: '9' },
        { type: 'math', question: '13 + 29', answer: '42' },
        // 5 new math
        { type: 'math', question: '144 / 12', answer: '12' },
        { type: 'math', question: '25 x 4', answer: '100' },
        { type: 'math', question: '1000 - 387', answer: '613' },
        { type: 'math', question: '17 x 6', answer: '102' },
        { type: 'math', question: '256 / 16', answer: '16' },
        // 5 mathChoice
        { type: 'mathChoice', question: 'What is 15% of 200?', answer: '30', choices: ['20', '25', '30', '35'] },
        { type: 'mathChoice', question: 'Greatest common factor of 12 and 18?', answer: '6', choices: ['3', '6', '9', '12'] },
        { type: 'mathChoice', question: 'Least common multiple of 4 and 6?', answer: '12', choices: ['12', '18', '24', '36'] },
        { type: 'mathChoice', question: 'What is 3/4 as a decimal?', answer: '0.75', choices: ['0.25', '0.50', '0.75', '0.34'] },
        { type: 'mathChoice', question: 'Order of operations acronym?', answer: 'PEMDAS', choices: ['PEMDAS', 'BODMAS', 'SADMEP', 'PEDMAS'] }
    ],

    algebra: [
        // Original 5
        { type: 'math', question: 'Solve for x: x + 5 = 12', answer: '7' },
        { type: 'math', question: 'Solve for x: 2x = 10', answer: '5' },
        { type: 'math', question: 'Solve for y: y - 3 = 7', answer: '10' },
        { type: 'math', question: 'Solve for x: 3x + 2 = 11', answer: '3' },
        { type: 'math', question: 'Solve for x: x^2 = 16', answer: '4' },
        // 5 new math
        { type: 'math', question: 'Solve for x: 5x - 3 = 22', answer: '5' },
        { type: 'math', question: 'Solve for x: x/4 = 7', answer: '28' },
        { type: 'math', question: 'Simplify: 3(x + 2) when x = 4', answer: '18' },
        { type: 'math', question: 'Solve for x: 2x + 3 = x + 8', answer: '5' },
        { type: 'math', question: 'Evaluate: 2^5', answer: '32' },
        // 5 mathChoice
        { type: 'mathChoice', question: 'Slope-intercept form?', answer: 'y = mx + b', choices: ['y = mx + b', 'ax + by = c', 'y - y1 = m(x - x1)', 'x = -b/2a'] },
        { type: 'mathChoice', question: 'Quadratic formula gives?', answer: 'Roots of ax^2+bx+c=0', choices: ['Roots of ax^2+bx+c=0', 'Slope of a line', 'Area of a circle', 'Volume of a cube'] },
        { type: 'mathChoice', question: 'If f(x) = 2x + 1, f(3) = ?', answer: '7', choices: ['5', '6', '7', '8'] },
        { type: 'mathChoice', question: 'Zero of f(x) = x - 5?', answer: '5', choices: ['0', '-5', '5', '10'] },
        { type: 'mathChoice', question: 'What does the discriminant determine?', answer: 'Number of real roots', choices: ['Number of real roots', 'Y-intercept', 'Slope', 'Vertex'] }
    ],

    geometry: [
        // 10 math
        { type: 'math', question: 'Area of rectangle: length 8, width 5', answer: '40' },
        { type: 'math', question: 'Perimeter of square with side 7', answer: '28' },
        { type: 'math', question: 'Area of triangle: base 10, height 6', answer: '30' },
        { type: 'math', question: 'Circumference of circle: radius 7 (use 22/7)', answer: '44' },
        { type: 'math', question: 'Sum of angles in a triangle', answer: '180' },
        { type: 'math', question: 'Volume of cube with side 3', answer: '27' },
        { type: 'math', question: 'Area of square with side 9', answer: '81' },
        { type: 'math', question: 'Hypotenuse: legs 3 and 4', answer: '5' },
        { type: 'math', question: 'Sum of interior angles of a hexagon', answer: '720' },
        { type: 'math', question: 'Volume of rectangular prism: 4 x 5 x 3', answer: '60' },
        // 5 mathChoice
        { type: 'mathChoice', question: 'How many sides does a pentagon have?', answer: '5', choices: ['4', '5', '6', '7'] },
        { type: 'mathChoice', question: 'Pythagorean theorem?', answer: 'a^2 + b^2 = c^2', choices: ['a^2 + b^2 = c^2', 'a + b = c', 'a^2 - b^2 = c^2', '2a + 2b = c'] },
        { type: 'mathChoice', question: 'Area of a circle formula?', answer: 'pi * r^2', choices: ['pi * r^2', '2 * pi * r', 'pi * d', 'pi * r^3'] },
        { type: 'mathChoice', question: 'Angles in a quadrilateral sum to?', answer: '360', choices: ['180', '270', '360', '540'] },
        { type: 'mathChoice', question: 'What is a polygon with 8 sides?', answer: 'Octagon', choices: ['Hexagon', 'Heptagon', 'Octagon', 'Nonagon'] }
    ],

    trigonometry: [
        // Original 5
        { type: 'math', question: 'sin(30)', answer: '0.5' },
        { type: 'math', question: 'cos(60)', answer: '0.5' },
        { type: 'math', question: 'tan(45)', answer: '1' },
        { type: 'math', question: 'sin^2(x) + cos^2(x)', answer: '1' },
        { type: 'mathChoice', question: 'Pythagorean identity?', answer: 'sin^2 + cos^2 = 1', choices: ['sin^2 + cos^2 = 1', 'sin^2 - cos^2 = 1', 'sin + cos = 1', 'tan = sin/cos'] },
        // 5 new math
        { type: 'math', question: 'cos(0)', answer: '1' },
        { type: 'math', question: 'sin(90)', answer: '1' },
        { type: 'math', question: 'tan(0)', answer: '0' },
        { type: 'math', question: 'sin(45) (decimal to 4 places)', answer: '0.7071' },
        { type: 'math', question: 'cos(180)', answer: '-1' },
        // 5 mathChoice
        { type: 'mathChoice', question: 'SOH-CAH-TOA: what is CAH?', answer: 'cos = adjacent/hypotenuse', choices: ['cos = adjacent/hypotenuse', 'cos = opposite/hypotenuse', 'cos = opposite/adjacent', 'cos = hypotenuse/adjacent'] },
        { type: 'mathChoice', question: 'Period of sin(x)?', answer: '2pi', choices: ['pi', '2pi', 'pi/2', '4pi'] },
        { type: 'mathChoice', question: 'tan(x) = ?', answer: 'sin(x)/cos(x)', choices: ['sin(x)/cos(x)', 'cos(x)/sin(x)', 'sin(x)*cos(x)', '1/sin(x)'] },
        { type: 'mathChoice', question: 'Inverse of sin is?', answer: 'arcsin', choices: ['arcsin', 'cosec', '1/sin', 'arccos'] },
        { type: 'mathChoice', question: 'How many degrees in a radian?', answer: '57.3 approximately', choices: ['57.3 approximately', '90', '180', '360'] }
    ],

    calculus: [
        // 10 math
        { type: 'math', question: 'Derivative of x^2', answer: '2x' },
        { type: 'math', question: 'Derivative of 5x^3', answer: '15x^2' },
        { type: 'math', question: 'Integral of 2x dx', answer: 'x^2 + C' },
        { type: 'math', question: 'Derivative of sin(x)', answer: 'cos(x)' },
        { type: 'math', question: 'Derivative of e^x', answer: 'e^x' },
        { type: 'math', question: 'Integral of 1/x dx', answer: 'ln|x| + C' },
        { type: 'math', question: 'Derivative of ln(x)', answer: '1/x' },
        { type: 'math', question: 'Derivative of cos(x)', answer: '-sin(x)' },
        { type: 'math', question: 'Integral of 3x^2 dx', answer: 'x^3 + C' },
        { type: 'math', question: 'Derivative of x^4', answer: '4x^3' },
        // 5 mathChoice
        { type: 'mathChoice', question: 'What does the derivative represent?', answer: 'Rate of change', choices: ['Rate of change', 'Area under curve', 'Maximum value', 'Average value'] },
        { type: 'mathChoice', question: 'Integral represents?', answer: 'Area under curve', choices: ['Area under curve', 'Slope at a point', 'Rate of change', 'Maximum value'] },
        { type: 'mathChoice', question: 'Limit as x->0 of sin(x)/x?', answer: '1', choices: ['0', '1', 'infinity', 'undefined'] },
        { type: 'mathChoice', question: 'Chain rule is used for?', answer: 'Composite functions', choices: ['Composite functions', 'Products', 'Quotients', 'Constants'] },
        { type: 'mathChoice', question: 'L\'Hopital\'s rule applies when?', answer: '0/0 or infinity/infinity', choices: ['0/0 or infinity/infinity', 'Always', 'Only polynomials', 'Only trig functions'] }
    ],

    statistics: [
        // 10 math
        { type: 'math', question: 'Mean of 2, 4, 6, 8, 10', answer: '6' },
        { type: 'math', question: 'Median of 3, 7, 8, 12, 15', answer: '8' },
        { type: 'math', question: 'Mode of 1, 2, 2, 3, 4, 2', answer: '2' },
        { type: 'math', question: 'Range of 5, 10, 15, 20, 25', answer: '20' },
        { type: 'math', question: 'Mean of 10, 20, 30', answer: '20' },
        { type: 'math', question: 'Median of 1, 3, 5, 7', answer: '4' },
        { type: 'math', question: 'Probability of heads on fair coin', answer: '0.5' },
        { type: 'math', question: 'Combinations: C(5,2)', answer: '10' },
        { type: 'math', question: 'Permutations: P(4,2)', answer: '12' },
        { type: 'math', question: 'Variance of 2, 4, 6 (population)', answer: '2.67' },
        // 5 mathChoice
        { type: 'mathChoice', question: 'Standard deviation measures?', answer: 'Spread of data', choices: ['Spread of data', 'Center of data', 'Shape of data', 'Size of data'] },
        { type: 'mathChoice', question: 'Normal distribution is shaped like?', answer: 'Bell curve', choices: ['Bell curve', 'Straight line', 'U-shape', 'Flat line'] },
        { type: 'mathChoice', question: 'Correlation of -1 means?', answer: 'Perfect negative correlation', choices: ['Perfect negative correlation', 'No correlation', 'Perfect positive correlation', 'Weak correlation'] },
        { type: 'mathChoice', question: 'P-value below 0.05 means?', answer: 'Statistically significant', choices: ['Statistically significant', 'Not significant', 'Error in data', 'Need more data'] },
        { type: 'mathChoice', question: 'What is a sample?', answer: 'Subset of a population', choices: ['Subset of a population', 'Entire population', 'Single data point', 'Statistical test'] }
    ],

    linear_algebra: [
        // 10 math
        { type: 'math', question: 'Determinant of [[1,2],[3,4]]', answer: '-2' },
        { type: 'math', question: 'Dot product of [1,2] and [3,4]', answer: '11' },
        { type: 'math', question: 'Transpose of [[1,2],[3,4]] first row', answer: '1,3' },
        { type: 'math', question: 'Trace of [[5,0],[0,3]]', answer: '8' },
        { type: 'math', question: 'Magnitude of vector [3,4]', answer: '5' },
        { type: 'math', question: 'Determinant of [[2,0],[0,3]]', answer: '6' },
        { type: 'math', question: 'Scalar multiply: 3 * [2,1]', answer: '[6,3]' },
        { type: 'math', question: 'Add vectors [1,2] + [3,4]', answer: '[4,6]' },
        { type: 'math', question: 'Rank of identity matrix 3x3', answer: '3' },
        { type: 'math', question: 'Eigenvalue of [[2,0],[0,5]] (smaller)', answer: '2' },
        // 5 mathChoice
        { type: 'mathChoice', question: 'Identity matrix has what on diagonal?', answer: '1s', choices: ['1s', '0s', '-1s', 'Varies'] },
        { type: 'mathChoice', question: 'A matrix with det = 0 is?', answer: 'Singular', choices: ['Singular', 'Invertible', 'Orthogonal', 'Symmetric'] },
        { type: 'mathChoice', question: 'Dot product of perpendicular vectors?', answer: '0', choices: ['0', '1', '-1', 'Undefined'] },
        { type: 'mathChoice', question: 'Number of rows x columns?', answer: 'Dimensions of matrix', choices: ['Dimensions of matrix', 'Determinant', 'Rank', 'Trace'] },
        { type: 'mathChoice', question: 'Inverse of A times A equals?', answer: 'Identity matrix', choices: ['Identity matrix', 'Zero matrix', 'A squared', 'Transpose of A'] }
    ],

    logic: [
        // 10 math
        { type: 'math', question: 'TRUE AND FALSE', answer: 'FALSE' },
        { type: 'math', question: 'TRUE OR FALSE', answer: 'TRUE' },
        { type: 'math', question: 'NOT TRUE', answer: 'FALSE' },
        { type: 'math', question: 'TRUE AND TRUE', answer: 'TRUE' },
        { type: 'math', question: 'FALSE OR FALSE', answer: 'FALSE' },
        { type: 'math', question: 'TRUE XOR TRUE', answer: 'FALSE' },
        { type: 'math', question: 'TRUE XOR FALSE', answer: 'TRUE' },
        { type: 'math', question: 'NOT (TRUE AND FALSE)', answer: 'TRUE' },
        { type: 'math', question: '(TRUE OR FALSE) AND TRUE', answer: 'TRUE' },
        { type: 'math', question: 'NOT (FALSE OR FALSE)', answer: 'TRUE' },
        // 5 mathChoice
        { type: 'mathChoice', question: 'De Morgan\'s law: NOT(A AND B) = ?', answer: 'NOT A OR NOT B', choices: ['NOT A OR NOT B', 'NOT A AND NOT B', 'A OR B', 'A AND B'] },
        { type: 'mathChoice', question: 'Modus ponens: If P then Q, P is true. Q is?', answer: 'True', choices: ['True', 'False', 'Unknown', 'Depends'] },
        { type: 'mathChoice', question: 'A tautology is always?', answer: 'True', choices: ['True', 'False', 'Unknown', 'Contradictory'] },
        { type: 'mathChoice', question: 'Contrapositive of "If P then Q"?', answer: 'If NOT Q then NOT P', choices: ['If NOT Q then NOT P', 'If Q then P', 'If NOT P then NOT Q', 'If P then NOT Q'] },
        { type: 'mathChoice', question: 'How many rows in truth table for 3 variables?', answer: '8', choices: ['4', '6', '8', '16'] }
    ],

    // ========== SCIENCE ==========

    physics: [
        // Original 5
        { type: 'mathChoice', question: "Newton's first law?", answer: 'Law of inertia', choices: ['Law of inertia', 'F=ma', 'Action-reaction', 'Conservation'] },
        { type: 'mathChoice', question: 'E=mc^2 means?', answer: 'Energy-mass equivalence', choices: ['Energy-mass equivalence', 'Electric charge', 'Electromagnetic force', 'Electron mass'] },
        { type: 'mathChoice', question: 'Speed of sound?', answer: '343 m/s', choices: ['343 m/s', '3000 m/s', '30 m/s', '3 m/s'] },
        { type: 'mathChoice', question: 'Unit of force?', answer: 'Newton', choices: ['Newton', 'Joule', 'Watt', 'Pascal'] },
        { type: 'mathChoice', question: 'Gravity on Earth?', answer: '9.8 m/s^2', choices: ['9.8 m/s^2', '10 m/s^2', '8.9 m/s^2', '11 m/s^2'] },
        // 10 new
        { type: 'mathChoice', question: 'Unit of energy?', answer: 'Joule', choices: ['Joule', 'Newton', 'Watt', 'Volt'] },
        { type: 'mathChoice', question: 'Speed of light?', answer: '3 x 10^8 m/s', choices: ['3 x 10^8 m/s', '3 x 10^6 m/s', '3 x 10^10 m/s', '3 x 10^5 m/s'] },
        { type: 'mathChoice', question: 'Ohm\'s law?', answer: 'V = IR', choices: ['V = IR', 'P = IV', 'F = ma', 'E = mc^2'] },
        { type: 'mathChoice', question: 'Unit of power?', answer: 'Watt', choices: ['Watt', 'Joule', 'Newton', 'Ampere'] },
        { type: 'mathChoice', question: 'Conservation of energy states?', answer: 'Energy cannot be created or destroyed', choices: ['Energy cannot be created or destroyed', 'Energy always increases', 'Energy only flows downhill', 'Energy equals mass'] },
        { type: 'mathChoice', question: 'What is frequency measured in?', answer: 'Hertz', choices: ['Hertz', 'Meters', 'Seconds', 'Newtons'] },
        { type: 'mathChoice', question: 'Kinetic energy formula?', answer: '1/2 mv^2', choices: ['1/2 mv^2', 'mgh', 'mv', 'ma'] },
        { type: 'mathChoice', question: 'Newton\'s third law?', answer: 'Every action has equal and opposite reaction', choices: ['Every action has equal and opposite reaction', 'F = ma', 'Objects at rest stay at rest', 'Energy is conserved'] },
        { type: 'mathChoice', question: 'Unit of electric charge?', answer: 'Coulomb', choices: ['Coulomb', 'Ampere', 'Volt', 'Ohm'] },
        { type: 'mathChoice', question: 'Acceleration due to gravity is?', answer: 'Constant near Earth surface', choices: ['Constant near Earth surface', 'Always 10 m/s^2', 'Variable everywhere', 'Zero in orbit'] }
    ],

    chemistry: [
        // Original 5
        { type: 'mathChoice', question: 'pH of pure water?', answer: '7', choices: ['7', '0', '14', '1'] },
        { type: 'mathChoice', question: 'Noble gas group?', answer: 'Group 18', choices: ['Group 18', 'Group 1', 'Group 7', 'Group 14'] },
        { type: 'mathChoice', question: 'Catalyst does what?', answer: 'Speeds reaction', choices: ['Speeds reaction', 'Slows reaction', 'Stops reaction', 'Reverses reaction'] },
        { type: 'mathChoice', question: 'Atomic number represents?', answer: 'Number of protons', choices: ['Number of protons', 'Number of neutrons', 'Number of electrons', 'Atomic mass'] },
        { type: 'mathChoice', question: 'Most abundant element?', answer: 'Hydrogen', choices: ['Hydrogen', 'Oxygen', 'Carbon', 'Nitrogen'] },
        // 10 new
        { type: 'mathChoice', question: 'Chemical symbol for gold?', answer: 'Au', choices: ['Au', 'Ag', 'Go', 'Gd'] },
        { type: 'mathChoice', question: 'Chemical symbol for sodium?', answer: 'Na', choices: ['Na', 'So', 'Sd', 'S'] },
        { type: 'mathChoice', question: 'How many elements in the periodic table (approx)?', answer: '118', choices: ['92', '103', '118', '150'] },
        { type: 'mathChoice', question: 'Water molecule formula?', answer: 'H2O', choices: ['H2O', 'HO2', 'H2O2', 'OH'] },
        { type: 'mathChoice', question: 'Acids have pH below?', answer: '7', choices: ['7', '0', '14', '10'] },
        { type: 'mathChoice', question: 'What is an ion?', answer: 'Atom with net charge', choices: ['Atom with net charge', 'Neutral atom', 'A molecule', 'An isotope'] },
        { type: 'mathChoice', question: 'Covalent bond involves?', answer: 'Sharing electrons', choices: ['Sharing electrons', 'Transferring electrons', 'Sharing protons', 'Magnetic attraction'] },
        { type: 'mathChoice', question: 'Avogadro\'s number?', answer: '6.022 x 10^23', choices: ['6.022 x 10^23', '3.14 x 10^8', '1.602 x 10^19', '9.81 x 10^2'] },
        { type: 'mathChoice', question: 'What is an isotope?', answer: 'Same element, different neutrons', choices: ['Same element, different neutrons', 'Different element, same mass', 'Same protons and neutrons', 'A charged atom'] },
        { type: 'mathChoice', question: 'Oxidation involves?', answer: 'Loss of electrons', choices: ['Loss of electrons', 'Gain of electrons', 'Loss of protons', 'Gain of neutrons'] }
    ],

    biology: [
        // Original 5
        { type: 'mathChoice', question: 'DNA base pairs?', answer: 'A-T, G-C', choices: ['A-T, G-C', 'A-G, T-C', 'A-C, T-G', 'A-A, T-T'] },
        { type: 'mathChoice', question: 'Photosynthesis produces?', answer: 'Glucose and oxygen', choices: ['Glucose and oxygen', 'Carbon dioxide', 'Water only', 'Nitrogen'] },
        { type: 'mathChoice', question: 'Human chromosomes?', answer: '46', choices: ['46', '23', '92', '48'] },
        { type: 'mathChoice', question: 'Largest organ?', answer: 'Skin', choices: ['Skin', 'Liver', 'Brain', 'Heart'] },
        { type: 'mathChoice', question: 'Powerhouse of the cell?', answer: 'Mitochondria', choices: ['Nucleus', 'Mitochondria', 'Ribosome', 'Chloroplast'] },
        // 10 new
        { type: 'mathChoice', question: 'DNA stands for?', answer: 'Deoxyribonucleic acid', choices: ['Deoxyribonucleic acid', 'Dinucleotide acid', 'Deoxyribose nucleic acid', 'Denatured nucleic acid'] },
        { type: 'mathChoice', question: 'What organelle controls the cell?', answer: 'Nucleus', choices: ['Nucleus', 'Mitochondria', 'Ribosome', 'Golgi body'] },
        { type: 'mathChoice', question: 'Process of cell division?', answer: 'Mitosis', choices: ['Mitosis', 'Osmosis', 'Diffusion', 'Respiration'] },
        { type: 'mathChoice', question: 'What carries oxygen in blood?', answer: 'Hemoglobin', choices: ['Hemoglobin', 'Plasma', 'White blood cells', 'Platelets'] },
        { type: 'mathChoice', question: 'Gregor Mendel is the father of?', answer: 'Genetics', choices: ['Genetics', 'Evolution', 'Ecology', 'Taxonomy'] },
        { type: 'mathChoice', question: 'What is the basic unit of life?', answer: 'Cell', choices: ['Cell', 'Atom', 'Molecule', 'Organ'] },
        { type: 'mathChoice', question: 'Photosynthesis occurs in?', answer: 'Chloroplasts', choices: ['Chloroplasts', 'Mitochondria', 'Nucleus', 'Ribosomes'] },
        { type: 'mathChoice', question: 'What is natural selection?', answer: 'Survival of the fittest', choices: ['Survival of the fittest', 'Random mutation', 'Genetic drift', 'Artificial breeding'] },
        { type: 'mathChoice', question: 'RNA differs from DNA by having?', answer: 'Uracil instead of thymine', choices: ['Uracil instead of thymine', 'Thymine instead of uracil', 'Two strands', 'Deoxyribose sugar'] },
        { type: 'mathChoice', question: 'Ecosystem includes?', answer: 'Living and non-living things', choices: ['Living and non-living things', 'Only animals', 'Only plants', 'Only microbes'] }
    ],

    astronomy: [
        { type: 'mathChoice', question: 'Closest star to Earth?', answer: 'The Sun', choices: ['The Sun', 'Proxima Centauri', 'Alpha Centauri', 'Sirius'] },
        { type: 'mathChoice', question: 'Largest planet in solar system?', answer: 'Jupiter', choices: ['Jupiter', 'Saturn', 'Neptune', 'Uranus'] },
        { type: 'mathChoice', question: 'How many planets in our solar system?', answer: '8', choices: ['7', '8', '9', '10'] },
        { type: 'mathChoice', question: 'Light year measures?', answer: 'Distance', choices: ['Distance', 'Time', 'Speed', 'Brightness'] },
        { type: 'mathChoice', question: 'What is a galaxy?', answer: 'Collection of stars and matter', choices: ['Collection of stars and matter', 'A single star', 'A planet system', 'A nebula'] },
        { type: 'mathChoice', question: 'Our galaxy is called?', answer: 'Milky Way', choices: ['Milky Way', 'Andromeda', 'Triangulum', 'Centaurus'] },
        { type: 'mathChoice', question: 'Red planet?', answer: 'Mars', choices: ['Mars', 'Jupiter', 'Venus', 'Mercury'] },
        { type: 'mathChoice', question: 'What causes tides?', answer: 'Moon\'s gravity', choices: ['Moon\'s gravity', 'Sun\'s gravity', 'Wind', 'Earth\'s rotation'] },
        { type: 'mathChoice', question: 'A supernova is?', answer: 'Exploding star', choices: ['Exploding star', 'New star forming', 'Black hole', 'Comet'] },
        { type: 'mathChoice', question: 'Smallest planet?', answer: 'Mercury', choices: ['Mercury', 'Mars', 'Venus', 'Pluto'] },
        { type: 'mathChoice', question: 'Planet known for its rings?', answer: 'Saturn', choices: ['Saturn', 'Jupiter', 'Uranus', 'Neptune'] },
        { type: 'mathChoice', question: 'Age of the universe (approx)?', answer: '13.8 billion years', choices: ['13.8 billion years', '4.5 billion years', '10 billion years', '20 billion years'] },
        { type: 'mathChoice', question: 'What is a black hole?', answer: 'Region where gravity prevents escape', choices: ['Region where gravity prevents escape', 'Empty space', 'Dark nebula', 'Dead star only'] },
        { type: 'mathChoice', question: 'Hubble\'s law relates to?', answer: 'Expansion of universe', choices: ['Expansion of universe', 'Planet orbits', 'Star brightness', 'Moon phases'] },
        { type: 'mathChoice', question: 'The asteroid belt is between?', answer: 'Mars and Jupiter', choices: ['Mars and Jupiter', 'Earth and Mars', 'Jupiter and Saturn', 'Venus and Earth'] }
    ],

    // ========== SKILLS ==========

    chess: [
        { type: 'mathChoice', question: 'How many squares on a chess board?', answer: '64', choices: ['36', '49', '64', '81'] },
        { type: 'mathChoice', question: 'Which piece can jump over others?', answer: 'Knight', choices: ['Knight', 'Bishop', 'Rook', 'Queen'] },
        { type: 'mathChoice', question: 'How does a pawn capture?', answer: 'Diagonally forward', choices: ['Diagonally forward', 'Straight forward', 'Any direction', 'Sideways'] },
        { type: 'mathChoice', question: 'Castling involves which pieces?', answer: 'King and rook', choices: ['King and rook', 'King and queen', 'King and bishop', 'King and knight'] },
        { type: 'mathChoice', question: 'En passant is a special move for?', answer: 'Pawns', choices: ['Pawns', 'Knights', 'Bishops', 'Rooks'] },
        { type: 'mathChoice', question: 'Most powerful piece?', answer: 'Queen', choices: ['Queen', 'King', 'Rook', 'Knight'] },
        { type: 'mathChoice', question: 'Stalemate result?', answer: 'Draw', choices: ['Draw', 'Win for attacker', 'Loss for defender', 'Restart'] },
        { type: 'mathChoice', question: 'Bishop moves?', answer: 'Diagonally', choices: ['Diagonally', 'Straight lines', 'L-shape', 'Any direction'] },
        { type: 'mathChoice', question: 'What is check?', answer: 'King is under attack', choices: ['King is under attack', 'King is captured', 'Game is over', 'Pawn reaches end'] },
        { type: 'mathChoice', question: 'Pawn promotion happens at?', answer: 'Opposite end of board', choices: ['Opposite end of board', 'Center of board', 'After 10 moves', 'After capturing'] },
        { type: 'mathChoice', question: 'Starting number of pieces per side?', answer: '16', choices: ['12', '14', '16', '20'] },
        { type: 'mathChoice', question: 'Rook moves?', answer: 'Horizontally and vertically', choices: ['Horizontally and vertically', 'Diagonally', 'L-shape', 'One square any direction'] },
        { type: 'mathChoice', question: 'What is a fork?', answer: 'One piece attacks two', choices: ['One piece attacks two', 'Two pieces attack one', 'Trading pieces', 'Blocking a check'] },
        { type: 'mathChoice', question: 'Point value of a knight?', answer: '3', choices: ['1', '3', '5', '9'] },
        { type: 'mathChoice', question: 'What is checkmate?', answer: 'King cannot escape attack', choices: ['King cannot escape attack', 'King is in check', 'All pieces captured', 'Time runs out'] }
    ],

    music_theory: [
        // Original 5
        { type: 'mathChoice', question: 'Circle of fifths starts?', answer: 'C', choices: ['C', 'A', 'G', 'F'] },
        { type: 'mathChoice', question: 'Time signature top number?', answer: 'Beats per measure', choices: ['Beats per measure', 'Note value', 'Tempo', 'Key signature'] },
        { type: 'mathChoice', question: 'Pentatonic scale notes?', answer: '5', choices: ['5', '7', '12', '8'] },
        { type: 'mathChoice', question: 'Common chord progression?', answer: 'I-V-vi-IV', choices: ['I-V-vi-IV', 'I-II-III-IV', 'V-IV-III-II', 'vi-V-IV-I'] },
        { type: 'mathChoice', question: 'Relative minor of C?', answer: 'A minor', choices: ['A minor', 'E minor', 'D minor', 'G minor'] },
        // 10 new
        { type: 'mathChoice', question: 'How many notes in a chromatic scale?', answer: '12', choices: ['7', '8', '10', '12'] },
        { type: 'mathChoice', question: 'Major scale intervals?', answer: 'W-W-H-W-W-W-H', choices: ['W-W-H-W-W-W-H', 'W-H-W-W-H-W-W', 'H-W-W-H-W-W-W', 'W-W-W-H-W-W-H'] },
        { type: 'mathChoice', question: 'What is a tritone?', answer: 'Interval of 3 whole steps', choices: ['Interval of 3 whole steps', '3 notes played together', 'A type of scale', 'A chord inversion'] },
        { type: 'mathChoice', question: 'How many sharps in G major?', answer: '1', choices: ['0', '1', '2', '3'] },
        { type: 'mathChoice', question: 'A major chord consists of?', answer: 'Root, major 3rd, perfect 5th', choices: ['Root, major 3rd, perfect 5th', 'Root, minor 3rd, perfect 5th', 'Root, 4th, 5th', 'Root, 2nd, 5th'] },
        { type: 'mathChoice', question: 'What does BPM stand for?', answer: 'Beats per minute', choices: ['Beats per minute', 'Bars per measure', 'Bass percussion mix', 'Basic pitch modulation'] },
        { type: 'mathChoice', question: 'A whole note lasts how many beats in 4/4?', answer: '4', choices: ['1', '2', '3', '4'] },
        { type: 'mathChoice', question: 'What is a diminished chord?', answer: 'Root, minor 3rd, diminished 5th', choices: ['Root, minor 3rd, diminished 5th', 'Root, major 3rd, perfect 5th', 'Root, minor 3rd, perfect 5th', 'Root, major 3rd, augmented 5th'] },
        { type: 'mathChoice', question: 'Middle C is which octave?', answer: 'C4', choices: ['C3', 'C4', 'C5', 'C2'] },
        { type: 'mathChoice', question: 'What is syncopation?', answer: 'Accent on weak beats', choices: ['Accent on weak beats', 'Playing in unison', 'Speeding up tempo', 'Playing softly'] }
    ],

    music_history: [
        { type: 'mathChoice', question: 'Who composed the Moonlight Sonata?', answer: 'Beethoven', choices: ['Beethoven', 'Mozart', 'Bach', 'Chopin'] },
        { type: 'mathChoice', question: 'Jazz originated in?', answer: 'New Orleans', choices: ['New Orleans', 'Chicago', 'New York', 'Memphis'] },
        { type: 'mathChoice', question: 'Who is the King of Pop?', answer: 'Michael Jackson', choices: ['Michael Jackson', 'Elvis Presley', 'Prince', 'Stevie Wonder'] },
        { type: 'mathChoice', question: 'The Beatles were from?', answer: 'Liverpool', choices: ['Liverpool', 'London', 'Manchester', 'Birmingham'] },
        { type: 'mathChoice', question: 'Who composed The Four Seasons?', answer: 'Vivaldi', choices: ['Vivaldi', 'Bach', 'Handel', 'Haydn'] },
        { type: 'mathChoice', question: 'Rock and roll emerged in the?', answer: '1950s', choices: ['1940s', '1950s', '1960s', '1970s'] },
        { type: 'mathChoice', question: 'Who is the King of Rock and Roll?', answer: 'Elvis Presley', choices: ['Elvis Presley', 'Chuck Berry', 'Little Richard', 'Buddy Holly'] },
        { type: 'mathChoice', question: 'Hip hop originated in?', answer: 'The Bronx, NYC', choices: ['The Bronx, NYC', 'Los Angeles', 'Atlanta', 'Detroit'] },
        { type: 'mathChoice', question: 'Who composed Symphony No. 9?', answer: 'Beethoven', choices: ['Beethoven', 'Mozart', 'Tchaikovsky', 'Brahms'] },
        { type: 'mathChoice', question: 'Woodstock festival was in?', answer: '1969', choices: ['1965', '1967', '1969', '1971'] },
        { type: 'mathChoice', question: 'Who invented the phonograph?', answer: 'Thomas Edison', choices: ['Thomas Edison', 'Alexander Bell', 'Nikola Tesla', 'Guglielmo Marconi'] },
        { type: 'mathChoice', question: 'Grunge music originated in?', answer: 'Seattle', choices: ['Seattle', 'Portland', 'San Francisco', 'Los Angeles'] },
        { type: 'mathChoice', question: 'Who composed The Magic Flute?', answer: 'Mozart', choices: ['Mozart', 'Beethoven', 'Wagner', 'Verdi'] },
        { type: 'mathChoice', question: 'Blues music originated in?', answer: 'Mississippi Delta', choices: ['Mississippi Delta', 'Chicago', 'New Orleans', 'Memphis'] },
        { type: 'mathChoice', question: 'Baroque period was approximately?', answer: '1600-1750', choices: ['1400-1600', '1600-1750', '1750-1820', '1820-1900'] }
    ],

    world_history: [
        // Original 5
        { type: 'mathChoice', question: 'Roman Empire fell?', answer: '476 AD', choices: ['476 AD', '1000 AD', '100 BC', '300 AD'] },
        { type: 'mathChoice', question: 'Renaissance began?', answer: '14th century', choices: ['14th century', '10th century', '17th century', '12th century'] },
        { type: 'mathChoice', question: 'Columbus sailed?', answer: '1492', choices: ['1492', '1500', '1485', '1512'] },
        { type: 'mathChoice', question: 'French Revolution?', answer: '1789', choices: ['1789', '1776', '1800', '1750'] },
        { type: 'mathChoice', question: 'World War I years?', answer: '1914-1918', choices: ['1914-1918', '1939-1945', '1910-1914', '1918-1922'] },
        // 10 new
        { type: 'mathChoice', question: 'Who built the Great Pyramid of Giza?', answer: 'Ancient Egyptians', choices: ['Ancient Egyptians', 'Romans', 'Greeks', 'Persians'] },
        { type: 'mathChoice', question: 'Berlin Wall fell in?', answer: '1989', choices: ['1985', '1987', '1989', '1991'] },
        { type: 'mathChoice', question: 'American Declaration of Independence?', answer: '1776', choices: ['1776', '1789', '1750', '1800'] },
        { type: 'mathChoice', question: 'Who was the first Emperor of China?', answer: 'Qin Shi Huang', choices: ['Qin Shi Huang', 'Kublai Khan', 'Sun Tzu', 'Confucius'] },
        { type: 'mathChoice', question: 'World War II ended in?', answer: '1945', choices: ['1943', '1944', '1945', '1946'] },
        { type: 'mathChoice', question: 'The Industrial Revolution began in?', answer: 'England', choices: ['England', 'France', 'Germany', 'United States'] },
        { type: 'mathChoice', question: 'Cold War was between?', answer: 'USA and USSR', choices: ['USA and USSR', 'USA and China', 'UK and Germany', 'France and Russia'] },
        { type: 'mathChoice', question: 'Ancient Greek democracy originated in?', answer: 'Athens', choices: ['Athens', 'Sparta', 'Rome', 'Corinth'] },
        { type: 'mathChoice', question: 'The Magna Carta was signed in?', answer: '1215', choices: ['1066', '1215', '1300', '1415'] },
        { type: 'mathChoice', question: 'Who discovered America (European)?', answer: 'Christopher Columbus', choices: ['Christopher Columbus', 'Amerigo Vespucci', 'Leif Erikson', 'Ferdinand Magellan'] }
    ],

    geography: [
        { type: 'mathChoice', question: 'Largest country by area?', answer: 'Russia', choices: ['Russia', 'Canada', 'China', 'United States'] },
        { type: 'mathChoice', question: 'Longest river in the world?', answer: 'Nile', choices: ['Nile', 'Amazon', 'Mississippi', 'Yangtze'] },
        { type: 'mathChoice', question: 'Largest ocean?', answer: 'Pacific', choices: ['Pacific', 'Atlantic', 'Indian', 'Arctic'] },
        { type: 'mathChoice', question: 'Capital of Japan?', answer: 'Tokyo', choices: ['Tokyo', 'Osaka', 'Kyoto', 'Seoul'] },
        { type: 'mathChoice', question: 'Highest mountain?', answer: 'Mount Everest', choices: ['Mount Everest', 'K2', 'Kangchenjunga', 'Mont Blanc'] },
        { type: 'mathChoice', question: 'How many continents?', answer: '7', choices: ['5', '6', '7', '8'] },
        { type: 'mathChoice', question: 'Largest desert?', answer: 'Sahara', choices: ['Sahara', 'Gobi', 'Arabian', 'Kalahari'] },
        { type: 'mathChoice', question: 'Capital of Australia?', answer: 'Canberra', choices: ['Canberra', 'Sydney', 'Melbourne', 'Brisbane'] },
        { type: 'mathChoice', question: 'Which country has the most people?', answer: 'India', choices: ['India', 'China', 'United States', 'Indonesia'] },
        { type: 'mathChoice', question: 'Capital of Brazil?', answer: 'Brasilia', choices: ['Brasilia', 'Rio de Janeiro', 'Sao Paulo', 'Salvador'] },
        { type: 'mathChoice', question: 'Largest lake by surface area?', answer: 'Caspian Sea', choices: ['Caspian Sea', 'Lake Superior', 'Lake Victoria', 'Lake Baikal'] },
        { type: 'mathChoice', question: 'The Amazon rainforest is mostly in?', answer: 'Brazil', choices: ['Brazil', 'Peru', 'Colombia', 'Venezuela'] },
        { type: 'mathChoice', question: 'Which continent is the driest?', answer: 'Antarctica', choices: ['Antarctica', 'Africa', 'Australia', 'Asia'] },
        { type: 'mathChoice', question: 'Capital of Canada?', answer: 'Ottawa', choices: ['Ottawa', 'Toronto', 'Vancouver', 'Montreal'] },
        { type: 'mathChoice', question: 'The Great Barrier Reef is off the coast of?', answer: 'Australia', choices: ['Australia', 'Indonesia', 'Philippines', 'Thailand'] }
    ],

    // ========== BC CURRICULUM ==========

    precalc11: [
        { type: 'math', question: 'Factor: x^2 - 5x + 6', answer: '(x-2)(x-3)' },
        { type: 'math', question: 'Solve: 2^(x+1) = 32', answer: '4' },
        { type: 'mathChoice', question: 'Arithmetic sequence: 3, 7, 11, ... Find a10', answer: '39', choices: ['35', '37', '39', '41'] },
        { type: 'math', question: 'Sum of geometric series: 2 + 6 + 18 + ... (4 terms)', answer: '80' },
        { type: 'mathChoice', question: 'Quadratic formula?', answer: 'x = (-b +/- sqrt(b^2-4ac))/2a', choices: ['x = (-b +/- sqrt(b^2-4ac))/2a', 'x = -b/2a', 'x = +/- sqrt(b^2-4ac)', 'x = -b +/- sqrt(b^2+4ac)/2a'] },
        { type: 'math', question: 'Complete the square: x^2 + 6x', answer: '(x+3)^2 - 9' },
        { type: 'mathChoice', question: 'Domain of f(x) = 1/(x-3)?', answer: 'All reals except x=3', choices: ['All reals', 'All reals except x=3', 'x>3', 'x<3'] },
        { type: 'math', question: 'Solve: |2x - 5| = 7', answer: 'x = 6 or x = -1' },
        { type: 'mathChoice', question: 'Compound interest formula?', answer: 'A = P(1 + r/n)^(nt)', choices: ['A = P(1 + r/n)^(nt)', 'A = Prt', 'A = Pe^(rt)', 'A = P + rt'] },
        { type: 'math', question: 'Rationalize: 1/sqrt(3)', answer: 'sqrt(3)/3' }
    ],

    precalc12: [
        { type: 'math', question: 'Convert to radians: 180 deg', answer: 'pi' },
        { type: 'math', question: 'Exact value: sin(pi/6)', answer: '1/2' },
        { type: 'mathChoice', question: 'Unit circle: cos(pi/2)', answer: '0', choices: ['0', '1', '-1', 'sqrt(2)/2'] },
        { type: 'math', question: 'Solve: sin(x) = 1/2, 0 <= x <= 2pi', answer: 'pi/6, 5pi/6' },
        { type: 'mathChoice', question: 'Amplitude of y = 3sin(2x)', answer: '3', choices: ['1', '2', '3', '6'] },
        { type: 'mathChoice', question: 'Period of y = sin(2x)', answer: 'pi', choices: ['2pi', 'pi', 'pi/2', '4pi'] },
        { type: 'mathChoice', question: 'Law of Sines?', answer: 'a/sin(A) = b/sin(B) = c/sin(C)', choices: ['a^2=b^2+c^2', 'a/sin(A) = b/sin(B)', 'sin(A)/a = sin(B)/b', 'a/sin(A) = b/sin(B) = c/sin(C)'] },
        { type: 'math', question: 'Evaluate: log3(27)', answer: '3' },
        { type: 'mathChoice', question: 'Exponential growth model?', answer: 'y = a * b^x', choices: ['y = mx + b', 'y = a * b^x', 'y = ax^2', 'y = a/x'] },
        { type: 'mathChoice', question: 'Number of permutations: P(5,3)', answer: '60', choices: ['20', '60', '120', '125'] }
    ],

    anatomy12: [
        { type: 'mathChoice', question: 'Number of bones in adult human?', answer: '206', choices: ['206', '213', '270', '300'] },
        { type: 'mathChoice', question: 'Largest bone?', answer: 'Femur', choices: ['Tibia', 'Femur', 'Humerus', 'Spine'] },
        { type: 'mathChoice', question: 'Three types of muscle?', answer: 'Skeletal, cardiac, smooth', choices: ['Skeletal, cardiac, smooth', 'Voluntary, involuntary, cardiac', 'Striated, smooth, rough', 'Fast, slow, cardiac'] },
        { type: 'mathChoice', question: 'Neurotransmitter at muscle junction?', answer: 'Acetylcholine', choices: ['Dopamine', 'Serotonin', 'Acetylcholine', 'GABA'] },
        { type: 'mathChoice', question: 'Basic unit of nervous system?', answer: 'Neuron', choices: ['Nerve', 'Neuron', 'Axon', 'Synapse'] },
        { type: 'mathChoice', question: 'Heart chambers?', answer: '4', choices: ['2', '3', '4', '5'] },
        { type: 'mathChoice', question: 'Gas exchange occurs in?', answer: 'Alveoli', choices: ['Bronchi', 'Bronchioles', 'Alveoli', 'Trachea'] },
        { type: 'mathChoice', question: 'Most absorption occurs in?', answer: 'Small intestine', choices: ['Stomach', 'Small intestine', 'Large intestine', 'Liver'] },
        { type: 'mathChoice', question: 'Master gland?', answer: 'Pituitary', choices: ['Thyroid', 'Pituitary', 'Adrenal', 'Pancreas'] },
        { type: 'mathChoice', question: 'Functional unit of kidney?', answer: 'Nephron', choices: ['Glomerulus', 'Nephron', 'Loop of Henle', 'Collecting duct'] }
    ]
};

// Auto-assign stable IDs to all questions for SRS tracking
Object.keys(questions).forEach(subject => {
    questions[subject].forEach((q, i) => {
        if (!q.id) q.id = `${subject}_${i}`;
    });
});

// Update categories to include BC curriculum
categories.math.subjects.push(
    { id: 'precalc11', name: 'Pre-Calculus 11', icon: 'fa-solid fa-book', level: 'BC Grade 12' },
    { id: 'precalc12', name: 'Pre-Calculus 12', icon: 'fa-solid fa-book-open', level: 'BC Grade 12' }
);

categories.science.subjects.push(
    { id: 'anatomy12', name: 'Anatomy & Physiology', icon: 'fa-solid fa-heart-pulse', level: 'BC Grade 12' }
);

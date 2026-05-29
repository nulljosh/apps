// ===== SUPABASE AUTH =====
const SB_URL = 'https://tjsxsqlxjmanwvmywwvw.supabase.co';
const SB_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRqc3hzcWx4am1hbnd2bXl3d3Z3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA0OTc0MDEsImV4cCI6MjA4NjA3MzQwMX0.LphLfho3wdQC20MhtcnBpzQUNuBoTOobrugQbNGxc68';
const ALLOWED_EMAIL = 'jatrommel@gmail.com';
// Supabase is a CDN dependency. If it fails to load, the app must still render
// read-only (and the ?pin=7743 bypass must still work) rather than blank out.
let _sb = null;
let _userId = null;
try {
  if (typeof supabase !== 'undefined') {
    _sb = supabase.createClient(SB_URL, SB_KEY);
    _sb.auth.getSession().then(res => {
      if (res.data.session) { _userId = res.data.session.user.id; loadAndShow(); }
    });
    _sb.auth.onAuthStateChange((_ev, session) => {
      if (session && !_userId) { _userId = session.user.id; loadAndShow(); }
    });
  }
} catch (e) { /* CDN unavailable — stay usable read-only */ }

function loadAndShow() {
  const overlay = document.getElementById('authOverlay');
  if (overlay) overlay.classList.add('hidden');
  initData();
}

document.getElementById('authFormEmail').addEventListener('submit', e => {
  e.preventDefault();
  const email = document.getElementById('authEmail').value.trim().toLowerCase();
  const errEl = document.getElementById('authErrEmail');
  if (email !== ALLOWED_EMAIL) { errEl.textContent = 'Access restricted.'; return; }
  document.getElementById('authConfirmedEmail').textContent = email;
  document.getElementById('authStep1').style.display = 'none';
  document.getElementById('authStep2').style.display = 'block';
  document.getElementById('authPassword').focus();
});

document.getElementById('authFormPass').addEventListener('submit', e => {
  e.preventDefault();
  const email = document.getElementById('authEmail').value.trim().toLowerCase();
  const password = document.getElementById('authPassword').value;
  const errEl = document.getElementById('authErrPass');
  const btn = e.submitter || e.target.querySelector('[type=submit]');
  btn.textContent = 'Signing in…'; btn.disabled = true;
  _sb.auth.signInWithPassword({ email, password }).then(res => {
    if (res.error) { errEl.textContent = res.error.message; btn.textContent = 'Sign in'; btn.disabled = false; }
  });
});

document.getElementById('authBack').addEventListener('click', () => {
  document.getElementById('authStep2').style.display = 'none';
  document.getElementById('authStep1').style.display = 'block';
  document.getElementById('authErrEmail').textContent = '';
  document.getElementById('authPassword').value = '';
});

// ===== DATA =====
const GROUNDS = [
  { id:'s8', n:'01', title:'Unreasonable search & seizure', sec:'Charter s.8', val:'$200-500k', high:500, grade:'A',
    desc:'Warrantless entry into a private dwelling on a non-criminal wellness call. Highest-tier s.8 violation under Feeney - the home is the most protected space in Charter jurisprudence. No exigent circumstances doctrine survives close scrutiny here: father present, plaintiff visible at kitchen table, no medical emergency observable from doorway. Subject was fully cooperative at the door: voluntarily discussed approximately 20 tattoos, answered officer questions coherently and amicably for several minutes. Declined only to discuss his family — when asked about his mother, brother, and sister, he didn\'t engage. Told officers he lived there with his father. That is all. The 911 call was placed by the father following a verbal disagreement — not a crime, not a threat, not an observable medical emergency. A cooperative, lucid subject at their own doorstep cannot ground a Feeney warrant exception.',
    cite:'R v. Feeney, [1997] 2 SCR 13 - warrantless dwelling entry presumptively unreasonable. R v. Godoy, [1999] 1 SCR 311 - limits 911-wellness entry to safety verification only.',
    risk:'AG argues Godoy wellness-call authority justified entry · Counter: Godoy permits safety verification only; Feeney makes warrantless dwelling entry presumptively unreasonable once restraint begins inside the home.' },
  { id:'s9', n:'02', title:'Arbitrary detention', sec:'Charter s.9', val:'$150-350k', high:350, grade:'A',
    desc:'Prone restraint, transport to hospital, overnight hold. No charge laid, no underlying crime. Detention must be authorized by law and not arbitrary - MHA s.28 threshold not met (father testimony defeats apprehension standard). Subject\'s sole non-compliance was declining to discuss his family when asked about his mother, brother, and sister. He told officers he lived there with his father — nothing more. That is the full extent of the non-cooperation that preceded detention. The 911 call originated from the father following a verbal disagreement between them. No crime. No threat. No observable harm risk. A cooperative, lucid person declining to answer personal family questions does not meet MHA s.28\'s requirement of a reasonable officer belief of likelihood of harm.',
    cite:'R v. Grant, 2009 SCC 32 - definition of detention. Mental Health Act (BC) s.28 - apprehension requires officer-formed belief of likelihood of harm.',
    risk:'AG argues MHA s.28 belief threshold was met on 911-call context · Counter: Grant requires non-arbitrary detention; subject was cogent and cooperative throughout — discussed ~20 tattoos with officers, declined only to discuss his family when asked — told officers he lived with his father, said nothing more (protected right to silence on personal matters). Father\'s verbal-argument 911 call plus subject\'s own cooperative conduct destroy the s.28 apprehension standard.' },
  { id:'s7', n:'03', title:'Life, liberty, security of person', sec:'Charter s.7', val:'$250-600k', high:600, grade:'A',
    desc:'Forced antipsychotic medication absent consent and absent meaningful incapacity assessment. Fleming v. Ontario establishes that even validly detained persons retain bodily integrity. Engages physical, psychological, and dignity interests simultaneously.',
    cite:'Fleming v. Ontario, 2019 SCC 45 - bodily integrity protected during state detention. Carter v. Canada, 2015 SCC 5 - s.7 protects against state-imposed physical intervention.',
    risk:'AG argues valid MHA detention lawfully limits s.7 under s.1 · Counter: Fleming holds bodily integrity survives lawful detention; forced antipsychotic medication without capacity assessment is not saved by s.1.' },
  { id:'s10b', n:'04', title:'Right to counsel', sec:'Charter s.10(b)', val:'$50-150k', high:150, grade:'C',
    desc:'No caution given at any point of the encounter. Detention triggered s.10(b) immediately under Grant; failure to inform of right to counsel before transport and forced medication compounds every downstream violation.',
    cite:'R v. Suberu, 2009 SCC 33 - s.10(b) attaches on detention without delay.',
    risk:'AG argues no formal arrest means s.10(b) did not attach · Counter: Suberu makes clear s.10(b) attaches on detention without delay — prone restraint was detention and no caution was given at any point.' },
  { id:'s12', n:'05', title:'Cruel & unusual treatment', sec:'Charter s.12', val:'$100-300k', high:300, grade:'B',
    desc:'Prone restraint by kneeling on the back created positional asphyxia risk. Forced antipsychotic injection followed by overnight solitary, no family notification, discharge without aftercare. The aggregate satisfies the s.12 grossly disproportionate threshold.',
    cite:'R v. Smith, [1987] 1 SCR 1045 - grossly disproportionate test. R v. Boudreault, 2018 SCC 58 - modern s.12 framework.',
    risk:'AG argues each measure was individually proportionate · Counter: Boudreault assesses s.12 in aggregate; prone restraint plus forced injection plus overnight solitary plus no aftercare satisfies Smith\'s grossly disproportionate test.' },
  { id:'battery', n:'06', title:'Battery & excessive force', sec:'common law tort', val:'$80-200k', high:200, grade:'B',
    desc:'Non-consensual physical contact exceeding any lawful authority. Pre-existing wrist fracture aggravated by restraint - additional special damages head. Standard of force assessed objectively per Anderson; officer notebooks must demonstrate proportionality, and the 30-second contact window per father testimony fails that standard.',
    cite:'Anderson v. Smith, 2010 BCCA - proportionality standard for police use of force.',
    risk:'AG argues force was objectively proportionate · Counter: Anderson requires proportionality to actual conduct; father confirms zero resistance before prone restraint, and the pre-existing wrist fracture aggravation is a separate special-damages head.' },
  { id:'falseimp', n:'07', title:'False imprisonment', sec:'common law tort', val:'$60-180k', high:180, grade:'B',
    desc:'Overnight solitary confinement absent lawful authority. Each hour past the s.28 examination window is independently actionable. Combined with hospital MHA Form 4 procedural review - was a Form 1 ever generated, signed, and on what evidentiary basis?',
    cite:'Bird v. The Queen, 2019 SCC 7 - false imprisonment within state custody.',
    risk:'AG argues MHA s.28 authorized the detention · Counter: Bird requires each hour beyond lawful authority to be independently justified; if no Form 1 was generated or the s.28 threshold was unmet, every hour of the overnight hold is actionable.' },
  { id:'iims', n:'08', title:'Negligent investigation', sec:'tort - Hill', val:'$50-150k', high:150, grade:'C',
    desc:'Officers owed a duty of care in investigation. Failure to verify wellness-call basis (911 audio defines this), failure to attempt verbal engagement before physical contact, failure to verify MHA s.28 threshold - all breach the Hill standard. Damages flow from downstream harms.',
    cite:'Hill v. Hamilton-Wentworth Regional Police, 2007 SCC 41 - duty of care in police investigation.',
    risk:'AG argues officers exercised reasonable real-time judgment · Counter: Hill imposes a duty of care; failure to attempt verbal engagement or verify the s.28 threshold before physical contact are discrete breaches causally tied to downstream harms.' },
];

const SCENARIOS = [
  { name:'Best case',   desc:'Full trial, all heads, Ward functions maximally triggered, punitive granted.', amt:'$2-3M',      pct:15, color:'var(--good)' },
  { name:'Strong',      desc:'Settlement with silence premium, evidence fully assembled, press-capable counsel.', amt:'$1.5-2.5M', pct:30, color:'var(--info)' },
  { name:'Most likely', desc:'AG settles to suppress precedent. Confidentiality clause standard.',           amt:'$1.2-1.8M', pct:40, color:'var(--warn)' },
  { name:'Limitation pressure', desc:'Limitation read comes back weak, or early settlement without leverage. Still a live floor given 8 breaches and no underlying crime.', amt:'$800k-1.2M', pct:15, color:'var(--danger)' },
];

const STACK_HEADS = [
  { label:'Charter s.24(1) damages',        sub:'Ward - compensation + vindication + deterrence', low:200, high:500, grade:'A' },
  { label:'Future earning capacity',         sub:'Age 26, 35+ working years; vocational economist', low:300, high:600, grade:'A' },
  { label:'General / non-pecuniary',         sub:'Pain, suffering, loss of dignity, PTSD',         low:150, high:300, grade:'B' },
  { label:'Aggravated damages',              sub:'Deliberate, bad-faith state action',              low:100, high:200, grade:'B' },
  { label:'Punitive damages',                sub:'Egregious conduct, public deterrence',            low:100, high:400, grade:'B' },
  { label:'Loss of dignity head',            sub:'Forced medication, solitary, no aftercare',       low:100, high:200, grade:'B' },
  { label:'Special / medical, lost income',  sub:'Treatment, meds, time off, wrist injury',        low:50,  high:100, grade:'C' },
  { label:'Wrist injury / aggravation',      sub:'Pre-existing fracture worsened by restraint',    low:40,  high:80,  grade:'C' },
];

const SCALE = [
  { band:'Canadian CAD', max:8100,
    marks:[
      { k:55,   lbl:'Tort floor' },
      { k:317,  lbl:'Degen 2023 BCSC', grp:'warn' },
      { k:1000, lbl:'This case - likely', isThis:true },
      { k:2500, lbl:'Trial ceiling', grp:'good' },
      { k:8100, lbl:'Henry v. BC', grp:'mid' },
    ],
    rows:[
      { name:'Degen v. Min. Public Safety',   yr:'2023 BCSC', v:'$317k',        note:'Surrey RCMP - force + PTSD' },
      { name:'Mona Wang v. AG Canada',         yr:'2021',      v:'confidential', note:'BC RCMP wellness check (closest parallel)' },
      { name:'This case / settlement median', yr:'projected', v:'$800k-1.2M',   note:'AG silence premium' },
      { name:'This case / trial ceiling',      yr:'projected', v:'$2-3M',        note:'Ward maxed, punitive granted' },
      { name:'Henry v. British Columbia',      yr:'2016 BCSC', v:'$8.1M',        note:'wrongful conviction ceiling' },
    ]},
  { band:'Global USD reference', max:45000,
    marks:[
      { k:1000,  lbl:'Federal 1983 median' },
      { k:15000, lbl:'Elijah McClain', grp:'warn', isThis:true },
      { k:27000, lbl:'Breonna Taylor', grp:'mid' },
      { k:45000, lbl:'Randy Cox', grp:'mid' },
    ],
    rows:[
      { name:'Elijah McClain estate',     yr:'2023 USD', v:'$15M',   note:'Aurora PD - closest fact pattern' },
      { name:'Breonna Taylor settlement', yr:'2020 USD', v:'$12M',   note:'Louisville - warrantless entry' },
      { name:'George Floyd estate',       yr:'2021 USD', v:'$27M',   note:'Minneapolis PD' },
      { name:'Randy Cox',                 yr:'2023 USD', v:'$45M',   note:'in-custody paralysis - ceiling' },
      { name:'NYC misconduct payouts',    yr:'FY 2024',  v:'$1.94B', note:'systemic baseline' },
    ]},
];

const LAWYERS = [
  { id:'law-society',      init:'LS', name:'Law Society of BC', sub:'Lawyer Referral Service - paid limitation read - 30-min, then $25 - PRIORITY',
    tags:[{t:'Limitation opinion',c:'urgent'},{t:'Survive a strike?',c:'urgent'},{t:'PRIORITY',c:'urgent'}], status:'none', fit:5,
    contacts:[{label:'1-800-663-1919',href:'tel:18006631919',kind:'tel',primary:true},{label:'lawsocietybc.ca',href:'https://lawsocietybc.ca',kind:'web'}] },
  { id:'thomas-harding',   init:'TH', name:'Thomas Harding', sub:'Thomas Harding Law Corp (TLAG) - Surrey BC - PK referral - Degen $317k',
    tags:[{t:'Degen case $317k',c:'good'},{t:'RCMP misconduct',c:'good'},{t:'PK referral',c:'urgent'},{t:'PRIORITY',c:'urgent'}], status:'none', fit:5,
    contacts:[{label:'604-635-1330',href:'tel:6046351330',kind:'tel',primary:true},{label:'tlag.ca',href:'https://tlag.ca',kind:'web'}] },
  { id:'neil-chantler',    init:'NC', name:'Neil Chantler', sub:'Chantler & Company - Vancouver BC - PK referral',
    tags:[{t:'Civil rights',c:'good'},{t:'PK referral',c:'urgent'},{t:'PRIORITY',c:'urgent'}], status:'none', fit:4,
    contacts:[{label:'604-424-8454',href:'tel:6044248454',kind:'tel',primary:true},{label:'neilchantler@chantlerlaw.ca',href:'mailto:neilchantler@chantlerlaw.ca',kind:'email'},{label:'chantlerlaw.ca',href:'https://chantlerlaw.ca',kind:'web'}] },
  { id:'paul-kent',        init:'PK', name:'Paul G. Kent-Snowsell', sub:'Kane Shannon & Weiler - Surrey BC - Of Counsel',
    tags:[{t:'33 yrs trial',c:'good'},{t:'Sued RCMP',c:'good'}], status:'voicemail', fit:4,
    contacts:[{label:'604-591-7321',href:'tel:6045917321',kind:'tel',primary:true},{label:'pgkent@kswlawyers.ca',href:'mailto:pgkent@kswlawyers.ca',kind:'email'}] },
  { id:'cameron-ward',     init:'CW', name:'Cameron Ward', sub:'Cameron Ward & Co - Gastown, Vancouver BC - 40+ yrs',
    tags:[{t:'Ward v. Vancouver SCC',c:'good'},{t:'Charter & police',c:'good'}], status:'emailed', fit:5,
    contacts:[{label:'604-688-6881',href:'tel:6046886881',kind:'tel',primary:true},{label:'cward@cameronward.com',href:'mailto:cward@cameronward.com',kind:'email'},{label:'cameronward.com',href:'https://cameronward.com',kind:'web'}] },
  { id:'arvay-finlay',     init:'AF', name:'Arvay Finlay LLP', sub:'Vancouver BC',
    tags:[{t:'Fairy Creek RCMP class',c:'good'},{t:'Charter ss.2/7/8/9',c:'good'},{t:'Declined May 25',c:'fail'}], status:'declined', fit:4,
    contacts:[{label:'604-696-9928',href:'tel:6046969928',kind:'tel'},{label:'arvayfinlay.ca',href:'https://arvayfinlay.ca',kind:'web'}] },
  { id:'klein-lawyers',    init:'KL', name:'Klein Lawyers', sub:'1385 W 8th Ave #400 - Vancouver BC - declined, class-action only',
    tags:[{t:'RCMP class actions',c:'good'},{t:'Declined',c:'fail'}], status:'declined', fit:3,
    contacts:[{label:'604-874-7171',href:'tel:6048747171',kind:'tel',primary:true},{label:'callkleinlawyers.com',href:'https://callkleinlawyers.com',kind:'web'}] },
  { id:'dla-law',          init:'DL', name:'DLA Law', sub:'Dosanjh Ladner Arora - Vancouver BC',
    tags:[{t:'Police misconduct',c:'good'},{t:'Wrongful arrest',c:'good'}], status:'emailed', fit:3,
    contacts:[{label:'604-327-6381',href:'tel:6043276381',kind:'tel'},{label:'Ingrid@dlalaw.ca',href:'mailto:Ingrid@dlalaw.ca',kind:'email'}] },
  { id:'bccla',            init:'BC', name:'BCCLA Referral Line', sub:'BC Civil Liberties Association',
    tags:[{t:'Free referrals',c:'good'},{t:'Civil rights',c:'good'}], status:'none', fit:2,
    contacts:[{label:'604-687-2919',href:'tel:6046872919',kind:'tel'},{label:'bccla.org',href:'https://bccla.org',kind:'web'}] },
  { id:'mcquarrie-hunter', init:'MH', name:'McQuarrie Hunter LLP', sub:'Surrey BC',
    tags:[{t:'BC Limitation Act',c:'good'},{t:'Discoverability / s.19',c:'good'}], status:'voicemail', fit:3,
    contacts:[{label:'604-581-7001',href:'tel:6045817001',kind:'tel'}] },
  { id:'sean-hern',        init:'SH', name:'Sean Hern Law Corp.', sub:'Vancouver BC - formerly Farris LLP',
    tags:[{t:'Pro bono',c:'good'},{t:'BC FOI/Privacy',c:'good'}], status:'none', fit:2,
    contacts:[{label:'604-684-9151',href:'tel:6046849151',kind:'tel'}] },
  { id:'cba-bc',           init:'CB', name:'Canadian Bar Association BC', sub:'Lawyer Referral Service',
    tags:[{t:'Free referrals',c:'good'},{t:'No answer',c:'warn'}], status:'emailed', fit:1,
    contacts:[{label:'604-687-3221',href:'tel:6046873221',kind:'tel'},{label:'info@cbabc.org',href:'mailto:info@cbabc.org',kind:'email'}] },
  { id:'dinsley',          init:'SD', name:'Dinsley Litigation', sub:'Sean Dinsley - Maple Ridge BC - civil litigation & personal injury',
    tags:[{t:'Civil litigation',c:'good'},{t:'Personal injury',c:'good'}], status:'none', fit:3,
    contacts:[{label:'604-477-0766',href:'tel:6044770766',kind:'tel',primary:true},{label:'admin@dinsleylawcorp.ca',href:'mailto:admin@dinsleylawcorp.ca',kind:'email'},{label:'dinsleylawcorp.ca',href:'https://dinsleylawcorp.ca',kind:'web'}] },
];

const TIMELINE = [
  { when:'Now',          state:'now',  title:'Get the paid limitation read',  desc:'Five specialist declines (PK, DLA, Ward, Arvay, Klein) is the market\'s answer on viability. Book a paid Law Society limitation read (1-800-663-1919) - one question: does this survive a strike? Stop cold-pitching contingency firms until that answer is in hand.' },
  { when:'Month 1-2',    state:'',     title:'Evidence build',           desc:'Police report, ATIP, E-Comm FOI, hospital ROI, BWC, OPCC to CRCC complaint, PTSD diagnosis letter.' },
  { when:'Month 2-4',    state:'warn', title:'Claim filed',              desc:'Basic limit expired Aug 2025. If discoverability holds, file immediately - every day increases risk.' },
  { when:'Month 6-18',   state:'',     title:'Discovery & negotiation',  desc:'Evidence exchanged. Settlement talks begin. Federal AG typically prefers quiet settlement.' },
  { when:'Month 12-24',  state:'good', title:'Settlement',               desc:'Approx 80% of cases settle before trial. Lump sum + confidentiality.' },
  { when:'Year 2-4',     state:'bad',  title:'Trial if no settlement',   desc:'Rare. Longer, riskier, higher payout potential. Kent has 100+ trials of record.' },
];

const CHECKLIST = [
  { i:'0',  label:'Call Paul Kent-Snowsell - book appointment',                pri:'now',  done:true,  lev:20 },
  { i:'1',  label:'PTSD assessment started (therapy) - get Dx letter',         pri:'now',  done:true,  lev:80 },
  { i:'2',  label:'Body cam footage requested from RCMP',                       pri:'now',  done:false, lev:120 },
  { i:'3',  label:'Police report - confirm officer identities via ATIP (names unknown)', pri:'now',  done:false, lev:45 },
  { i:'4',  label:'Hospital discharge records',                                 pri:'now',  done:false, lev:55 },
  { i:'5',  label:'Pain journal - daily entries',                               pri:'now',  done:false, lev:30 },
  { i:'6',  label:'Therapist letter confirming PTSD & causation',               pri:'now',  done:false, lev:100 },
  { i:'7',  label:'CRCC complaint - window likely closed; ask about an extension (federal, not OPCC)', pri:'soon', done:false, lev:25 },
  { i:'8',  label:'Father witness statement documented',                        pri:'soon', done:true,  lev:60 },
  { i:'9',  label:'Incident date confirmed: Aug 1, 2023 - File 2023-25586',    pri:'now',  done:true,  lev:10 },
  { i:'10', label:'Hospital name confirmed',                                    pri:'soon', done:true,  lev:15 },
  { i:'11', label:'Career & personality impact documented',                     pri:'soon', done:false, lev:40 },
  { i:'12', label:'Therapist letter: PTSD + incapacity period + causation',    pri:'now',  done:false, lev:90 },
  { i:'13', label:'Pin discovery date: May 11, 2026',                          pri:'now',  done:true,  lev:50 },
  { i:'14', label:'ATIP filed with RCMP - officer names, notebooks, BWC',      pri:'now',  done:false, lev:70 },
  { i:'15', label:'FOI filed with E-Comm 9-1-1 BC - 911 audio + CAD notes',   pri:'now',  done:false, lev:65 },
  { i:'16', label:'Email outreach: Ward (declined), Arvay (declined May 25), Klein, BCCLA', pri:'now',  done:true, lev:30 },
  { i:'17', label:'Contact Thomas Harding - TLAG 604-635-1330 (Degen $317k, PK referral) - TOP PRIORITY', pri:'now', done:false, lev:150 },
  { i:'18', label:'Contact Neil Chantler - 604-424-8454 / neilchantler@chantlerlaw.ca (PK referral) - TOP PRIORITY', pri:'now', done:false, lev:140 },
  { i:'19', label:'Contact Dinsley Litigation - Sean Dinsley 604-477-0766 (Maple Ridge, civil litigation + PI)', pri:'now', done:false, lev:35 },
  { i:'20', label:'Call CBA BC Lawyer Referral Service - 604-687-3221 / info@cbabc.org', pri:'soon', done:false, lev:20 },
  { i:'21', label:'PRIORITY: Book Law Society limitation read (1-800-663-1919) - does this survive a limitation strike, yes or no?', pri:'now', done:false, lev:160 },
  { i:'22', label:'Get s.19 letter from current counsellor: PTSD Dx + causation to Aug 1 2023 + period of incapacity', pri:'now', done:false, lev:100 },
  { i:'23', label:'Request GP pre-incident records - establish pre-Aug 2023 baseline functioning', pri:'now', done:false, lev:40 },
];

const JOURNAL_SEED = [
  { date:'2026-05-11', text:'May 11, 2026 — pinned as formal discovery date for s.8(1)(d) discoverability argument.' },
  { date:'2026-04-22', text:'Therapy started May 2026. PTSD causation letter pending.' },
];

const CALL_SCRIPT = '30-SECOND COLD CALL — use verbatim:\n"Hi, my name is Josh Trommel. I have a Charter damages claim against the Attorney General of Canada — warrantless RCMP entry during a wellness call in Langley, August 2023, forced hospitalisation, forced antipsychotic medication, documented PTSD. I\'m looking to retain counsel. The basic two-year limit has passed but I have strong discoverability and incapacity arguments. I\'d like to book a consultation."\n\n---\n\nFULL CONSULTATION PREP:\n\nIntroduction: "My name is Joshua Trommel. I am following up on my email about a civil claim arising from a warrantless RCMP wellness-call entry in August 2023."\n\nKey facts (30 seconds):\n- Date: August 1, 2023, approx 11:00 AM, Langley BC (Brookswood detachment)\n- No underlying crime. Father present. I was sitting at kitchen table.\n- I was fully cooperative — answered officer questions including discussing approximately 20 tattoos. When asked about my family, I wouldn\'t discuss them. I told officers I lived there with my father — that was it. The 911 call was placed by my father after a verbal disagreement between us.\n- RCMP entered without warrant, restrained me within 30 seconds (prone, knee on back).\n- Transported to hospital, overnight hold, forced antipsychotic injection.\n- No s.10(b) caution at any point. File: 2023-25586.\n\nCharter grounds: ss. 7, 8, 9, 10(b), 12 + battery + false imprisonment.\n\nLimitation: Basic 2-year expired Aug 2025. Survived on discoverability (s.8(1)(d)) and PTSD incapacity (s.19). Discovery date: May 11, 2026.\n\nDefendant: Attorney General of Canada (RCMP is federal).\n\nDamages ask: $1.5-2.5M settlement; $2-3M trial ceiling.\n\nQuestions for counsel:\n1. Do you take civil rights / Charter police misconduct cases?\n2. Retainer structure - flat or contingency?\n3. Have you acted against the AG / RCMP specifically?\n4. Are you press-capable if the AG stonewalls?\n5. When can we meet in person?';

// ===== CASE-0002: Trommel v. Trommel =====

let webActiveCase = 'rcmp';

const FAMILY_GROUNDS = [
  { id:'likeness', n:'01', title:'Appropriation of Personality', sec:'BC Privacy Act s.3', val:'$75–200k', high:200, grade:'A',
    desc:'Brian Trommel used Joshua\'s face and likeness on family business vehicles and advertising without consent. Commercial exploitation for financial gain. Ongoing tort — limitation runs from last use date or May 2026 discovery. Photograph every vehicle with timestamps.',
    cite:'BC Privacy Act RSBC 1996 c.373 s.3 · Krouse v. Chrysler Canada Ltd (1973)',
    risk:'Defendants argue use was incidental or consented by proximity to the family business · Counter: Krouse holds commercial exploitation without express consent is actionable; ongoing vehicle use keeps limitation running from the last use date.' },
  { id:'iims', n:'02', title:'Intentional Infliction of Mental Suffering', sec:'IIMS', val:'$100–200k', high:200, grade:'A',
    desc:'20+ year pattern of calculated conduct: police weaponized against Joshua at ages 10 and 15 for crying. Eviction into homelessness. Parking lot confrontation while Joshua was homeless — Brian\'s stated priority was a Yelp review, not his son\'s welfare. PTSD resulted.',
    cite:'Wilkinson v. Downton [1897] 2 QB 57 · Piresferreira v. Ayotte 2010 ONCA 384',
    risk:'Defendants argue conduct was normal parenting · Counter: Piresferreira confirms a sustained pattern satisfies Wilkinson; police weaponized twice, eviction into homelessness, and parking-lot Yelp confrontation collectively reach calculated outrage.' },
  { id:'negligence', n:'03', title:'Parental Negligence', sec:'Negligence', val:'$50–150k', high:150, grade:'B',
    desc:'Parents owed a duty of care. Breaches: calling police on a child for crying, evicting an adult child into homelessness, using police as a control mechanism. Causation to PTSD and lost earning capacity (age 26, 35+ working years). Psychiatric evidence must separate RCMP PTSD from family PTSD.',
    cite:'Jordan House Ltd v. Menow [1974] SCR 239',
    risk:'Defendants argue parental duty ends at majority · Counter: Jordan House recognizes duty where reliance and vulnerability persist; causation must be separated from RCMP PTSD by independent psychiatric evidence.' },
  { id:'battery', n:'04', title:'Battery — Non-Consensual Surgery', sec:'Battery', val:'$25–75k', high:75, grade:'C',
    desc:'Circumcision performed in infancy without capacity for consent. BC Limitation Act s.16 suspends limitation during minority — clock started at age 19 (~2019). Novel argument in BC — no direct appellate authority. Include as supplementary, not lead claim.',
    cite:'Malette v. Shulman (1990) 72 OR (2d) 417 · BC Limitation Act s.16',
    risk:'Defendants argue limitation has expired and procedure was standard medical care · Counter: Malette holds non-consensual contact is battery; Limitation Act s.16 suspends the clock during minority, placing start of limitation at approximately age 19.' },
  { id:'eviction', n:'05', title:'Wrongful Eviction', sec:'Negligence', val:'$25–75k', high:75, grade:'C',
    desc:'Evicted from the only family home with no notice or transition support. Subsequently located in a parking lot while homeless. Brian\'s stated priority: a Yelp review. Special damages: shelter costs, lost income during homeless period.',
    cite:'Parental duty of care · special damages causation',
    risk:'Defendants argue adults have no right to remain in a parent\'s home · Counter: parental duty survives financial dependence; the homeless parking-lot confrontation with Yelp as stated priority corroborates breach and causation for special damages.' },
];

const FAMILY_SCENARIOS = [
  { name:'Best case',   desc:'Full trial, all heads viable, punitive granted. Parents settle to avoid public judgment.', amt:'$1.5–2M',    pct:10, color:'var(--good)' },
  { name:'Strong',      desc:'Likeness + IIMS survive limitation. Settlement with real leverage.',                       amt:'$700k–1.2M', pct:25, color:'var(--info)' },
  { name:'Most likely', desc:'Likeness + recent IIMS survive. Childhood claims used for damages context only.',          amt:'$300k–600k', pct:45, color:'var(--warn)' },
  { name:'Worst',       desc:'Limitation kills most claims. Parents have assets but settle minimally.',                  amt:'$0–100k',    pct:20, color:'var(--danger)' },
];

const FAMILY_STACK_HEADS = [
  { label:'Appropriation of personality (ongoing)', sub:'BC Privacy Act s.3 — cleanest limitation',  low:75,  high:200, grade:'A' },
  { label:'IIMS — pattern of conduct',              sub:'Needs psychiatric proof of illness',          low:100, high:200, grade:'A' },
  { label:'Parental negligence — PTSD',             sub:'Must split from RCMP PTSD',                  low:50,  high:150, grade:'B' },
  { label:'Lost earning capacity',                  sub:'Age 26, 35+ working years',                  low:100, high:300, grade:'B' },
  { label:'Battery — non-consensual surgery',       sub:'Novel — lead with others',                   low:25,  high:75,  grade:'C' },
  { label:'Special (shelter, therapy, lost income)',sub:'Homelessness period',                         low:25,  high:75,  grade:'C' },
  { label:'Punitive',                               sub:'Parking lot + ongoing likeness use',          low:25,  high:100, grade:'C' },
];

const FAMILY_LAWYERS = [
  { id:'lawsociety-f', init:'LS', name:'Law Society of BC', sub:'Lawyer Referral Service · 30-min free, then $25',
    tags:[{t:'Civil tort referrals',c:'good'},{t:'Find a specialist',c:'good'}], status:'none', fit:4,
    contacts:[{label:'1-800-663-1919',href:'tel:18006631919',kind:'tel',primary:true},{label:'lawsocietybc.ca',href:'https://lawsocietybc.ca',kind:'web'}] },
  { id:'bccla-f', init:'BC', name:'BCCLA Referral Line', sub:'BC Civil Liberties Association',
    tags:[{t:'Free referrals',c:'good'},{t:'Civil rights',c:'good'}], status:'none', fit:3,
    contacts:[{label:'604-687-2919',href:'tel:6046872919',kind:'tel'},{label:'bccla.org',href:'https://bccla.org',kind:'web'}] },
  { id:'slater-vecchio', init:'SV', name:'Slater Vecchio LLP', sub:'Vancouver BC · Civil litigation, personal injury',
    tags:[{t:'Tort claims',c:'good'},{t:'Personal injury',c:'good'}], status:'none', fit:3,
    contacts:[{label:'slatervecchio.com',href:'https://slatervecchio.com',kind:'web'}] },
  { id:'harper-grey', init:'HG', name:'Harper Grey LLP', sub:'Vancouver BC · Civil litigation',
    tags:[{t:'Civil tort',c:'good'},{t:'Intentional torts',c:'good'}], status:'none', fit:3,
    contacts:[{label:'harpergrey.com',href:'https://harpergrey.com',kind:'web'}] },
  { id:'watson-goepel', init:'WG', name:'Watson Goepel LLP', sub:'Vancouver BC · Civil litigation',
    tags:[{t:'Civil tort',c:'good'},{t:'Limitation Act exp.',c:'good'}], status:'none', fit:3,
    contacts:[{label:'watsongoepel.com',href:'https://watsongoepel.com',kind:'web'}] },
];

const FAMILY_CHECKLIST = [
  { i:'f0',  label:'Photograph all vehicles / materials with your likeness — timestamp every photo',      pri:'now',  done:false, lev:30 },
  { i:'f1',  label:'Screenshot online presence (website, social, Google My Business) using your image',   pri:'now',  done:false, lev:25 },
  { i:'f2',  label:'Write precise timeline of the homelessness period (dates, locations, witnesses)',      pri:'now',  done:false, lev:20 },
  { i:'f3',  label:'Preserve texts, emails, voicemails from parents re: eviction, parking lot, Yelp',    pri:'now',  done:false, lev:25 },
  { i:'f4',  label:'Find or reconstruct the Yelp review and any response from your father',              pri:'now',  done:false, lev:20 },
  { i:'f5',  label:'Document approximate dates of police calls at ages 10 and 15 (incident numbers)',    pri:'soon', done:false, lev:15 },
  { i:'f6',  label:'Identify witnesses to the homelessness period or parking lot confrontation',           pri:'soon', done:false, lev:15 },
  { i:'f7',  label:'Get therapy records documenting psychological harm from family (separate from RCMP)', pri:'soon', done:false, lev:20 },
  { i:'f8',  label:'Research family business: name, registration, revenue (bcregistry.gov.bc.ca)',        pri:'soon', done:false, lev:15 },
  { i:'f9',  label:'Pin discoverability date: May 2026 — formal written record',                         pri:'now',  done:false, lev:20 },
  { i:'f10', label:'Contact Law Society BC referral (1-800-663-1919) — ask for civil tort specialist',   pri:'now',  done:false, lev:30 },
  { i:'f11', label:'Audit digital footprint — anything that could be used against you',                   pri:'soon', done:false, lev:10 },
];

const FAMILY_TIMELINE = [
  { when:'Now',         state:'now',  title:'Find civil tort counsel',    desc:'Law Society referral: 1-800-663-1919. Ask for tort / intentional harm / appropriation of personality. NOT Charter — different practice area.' },
  { when:'Week 1–2',   state:'',     title:'Evidence gathering',         desc:'Photograph every vehicle with likeness. Screenshot online presence. Write precise dates for all incidents. Preserve texts, emails, voicemails.' },
  { when:'Month 1–2',  state:'',     title:'Limitation analysis',        desc:'Lawyer must assess which claims survive limitation. Discoverability formally documented. Pin May 2026 as discovery date.' },
  { when:'Month 2–6',  state:'warn', title:'Demand letter',              desc:'Without-prejudice demand to both defendants. Outlines claims, limitation basis, settlement figure. Sets negotiation clock.' },
  { when:'Month 6–18', state:'good', title:'File or settle',             desc:'Most civil cases settle once counsel retained and demand delivered. Parents own $1M+ home — judgment can be registered against title in BC.' },
  { when:'May 1, 2028',state:'bad',  title:'Hard deadline',              desc:'2-year basic limitation from May 2026 discovery. Must file or have documented discoverability argument before this date.' },
];

const FAMILY_CALL_SCRIPT = '30-SECOND — USE VERBATIM (Law Society referral):\n"Hi, my name is Josh Trommel. I\'m looking for a civil litigation lawyer with experience in intentional torts and appropriation of personality in BC. I have claims against my parents arising from commercial use of my likeness without consent, intentional infliction of mental suffering over a 20-year period, parental negligence, and wrongful eviction into homelessness. Discovery date is May 2026, basic limitation expires May 2028. I\'d like to book a 30-minute consultation."\n\n---\n\nFULL OUTREACH EMAIL:\nSubject: Civil Consultation — Appropriation of Personality / IIMS — Trommel\n\nHi [Name],\n\nMy name is Joshua Trommel. I\'m seeking a civil litigation lawyer with experience in intentional torts and/or appropriation of personality claims in BC.\n\nI have potential claims against my parents:\n1. Commercial use of my face and likeness on family business vehicles without consent — ongoing appropriation of personality tort under BC Privacy Act s.3.\n2. Intentional infliction of mental suffering — documented 20+ year pattern: eviction into homelessness, police weaponized during emotional distress, parking lot confrontation while homeless (father\'s stated priority: a Yelp review).\n3. Parental negligence contributing to documented PTSD.\n\nI have a separate Charter claim against the AG of Canada (RCMP). Discovery date: May 2026. Basic limitation expires May 2028.\n\nAvailable for consultation at your earliest convenience.\nJoshua Trommel · 778-201-4533';

function getActiveChecklist() { return webActiveCase === 'rcmp' ? CHECKLIST : FAMILY_CHECKLIST; }
const CL_STORE_FAMILY = 'brief.v3.checklist.family';
function getClStore() { return webActiveCase === 'rcmp' ? CL_STORE : CL_STORE_FAMILY; }

function setActiveCase(id) {
  webActiveCase = id;
  document.body.dataset.activecase = id;
  document.querySelectorAll('.cs-btn').forEach(b => b.classList.toggle('active', b.dataset.case === id));
  const f = document.getElementById('stripFile');
  if (f) f.textContent = id === 'rcmp' ? 'CASE-0001' : 'CASE-0002';
  document.title = id === 'rcmp' ? 'Brief — Trommel v. AG Canada' : 'Brief — Trommel v. Trommel';
  renderGrounds('grounds-case', '');
  renderGrounds('grounds-money', '2');
  renderScenarios();
  renderStack();
  document.querySelectorAll('.stack-toggle button').forEach(b => b.classList.toggle('active', b.dataset.m === stackMode));
  renderLawyers();
  renderChecklist();
  renderTimeline();
  if (id === 'rcmp') renderLeverage();
  const scriptEl = document.getElementById('scriptText');
  if (scriptEl) scriptEl.textContent = id === 'rcmp' ? CALL_SCRIPT : FAMILY_CALL_SCRIPT;
}

// ===== LEVERAGE =====
const LAWYER_LEVERAGE = { none:0, voicemail:5, emailed:15, callback:40, retained:180 };
const BASELINE_PROJECTION = 400;
const CEILING_PROJECTION  = 3000;

let _lawyerStatuses = {};
const STATUS_CYCLE = ['none','voicemail','emailed','callback','retained','declined'];
const STATUS_LABEL = { none:'Not contacted', voicemail:'Voicemail left', emailed:'Email sent', callback:'Callback received', retained:'Retained', declined:'Declined' };

function computeLeverage() {
  const evidence = CHECKLIST.reduce((s,x) => s + (x.done ? x.lev : 0), 0);
  let counselLev = 0, counselRetained = false;
  document.querySelectorAll('.tag.status').forEach(chip => {
    const st = chip.dataset.status;
    if (st === 'retained') {
      if (!counselRetained) { counselLev += LAWYER_LEVERAGE.retained; counselRetained = true; }
    } else if (LAWYER_LEVERAGE[st]) {
      counselLev += LAWYER_LEVERAGE[st];
    }
  });
  if (!counselRetained) counselLev = Math.min(counselLev, 80);
  const total = Math.min(CEILING_PROJECTION, BASELINE_PROJECTION + evidence + counselLev);
  return { evidence, counselLev, counselRetained, total };
}

function renderLeverage() {
  const el = document.getElementById('leverage-widget');
  if (!el) return;
  const { evidence, counselLev, counselRetained, total } = computeLeverage();
  const delta = total - BASELINE_PROJECTION;
  const pct = Math.min(100, ((total - BASELINE_PROJECTION) / (CEILING_PROJECTION - BASELINE_PROJECTION)) * 100);

  const tlv = document.getElementById('triLiveVal');
  if (tlv) {
    tlv.textContent = '$' + total + 'k';
    const tls = document.getElementById('triLiveSub');
    if (tls) tls.textContent = delta > 0 ? '+$' + delta + 'k earned through leverage' : 'baseline - no leverage yet';
  }

  pushSparkline(total);

  const pendingItems = CHECKLIST.filter(x => !x.done).sort((a,b) => b.lev - a.lev).slice(0,3);
  const counselLine = counselRetained ? '' :
    '<div class="lev-row"><div class="lev-row-l"><div class="lev-dot"></div><div>' +
    '<div class="lev-row-name">Retain counsel</div>' +
    '<div class="lev-row-sub">one signed retainer unlocks the biggest single step</div>' +
    '</div></div><div class="lev-row-amt tnum">+$' + LAWYER_LEVERAGE.retained + 'k</div></div>';

  const pendingLines = pendingItems.map(it =>
    '<div class="lev-row" data-cl="' + it.i + '">' +
    '<div class="lev-row-l"><div class="lev-dot"></div><div>' +
    '<div class="lev-row-name">' + it.label + '</div>' +
    '<div class="lev-row-sub">' + (it.pri === 'now' ? 'Priority - immediate' : 'Soon - pre-retainer') + '</div>' +
    '</div></div><div class="lev-row-amt tnum">+$' + it.lev + 'k</div></div>'
  ).join('');

  el.innerHTML =
    '<div class="section-hd"><div class="lbl"><b>Settlement leverage</b> - live projection</div><div class="hint">complete actions to move projection</div></div>' +
    '<div class="lev-card">' +
    '<div class="lev-tot">' +
    '<div class="lev-tot-l">' +
    '<div class="lev-tot-lbl">Projected settlement today</div>' +
    '<div class="lev-tot-val tnum" id="levTotVal">$' + total + 'k</div>' +
    '<div class="lev-tot-delta">' +
    '<span class="lev-delta-pill">+$' + delta + 'k vs baseline</span>' +
    '<span class="lev-tot-sub">baseline $' + BASELINE_PROJECTION + 'k - trial ceiling $' + (CEILING_PROJECTION/1000).toFixed(2) + 'M</span>' +
    '</div></div>' +
    '<div class="lev-tot-r"><div class="lev-breakdown">' +
    '<div class="lev-bd-row"><span>Baseline</span><span class="tnum">$' + BASELINE_PROJECTION + 'k</span></div>' +
    '<div class="lev-bd-row"><span>Evidence built</span><span class="tnum lev-pos">+$' + evidence + 'k</span></div>' +
    '<div class="lev-bd-row"><span>Counsel posture</span><span class="tnum lev-pos">+$' + counselLev + 'k</span></div>' +
    '</div></div></div>' +
    '<div class="lev-bar">' +
    '<div class="lev-bar-track"></div>' +
    '<div class="lev-bar-fill" style="width:' + pct + '%"></div>' +
    '<div class="lev-bar-marker" style="left:' + pct + '%"></div>' +
    '<div class="lev-bar-anchors"><span>Baseline</span>' +
    '<span style="position:absolute;left:' + pct + '%;transform:translateX(-50%);color:var(--danger);">$' + total + 'k</span>' +
    '<span>Ceiling</span></div>' +
    '</div></div>' +
    '<div class="lev-list"><div class="lev-list-hd">Top levers not yet pulled</div>' +
    counselLine + pendingLines + '</div>';

  const pill = document.getElementById('pillVal');
  if (pill) pill.textContent = '$' + total + 'k';

  renderTrajectory(total);
}

function pushSparkline(v) {
  const KEY = 'brief.v3.spark';
  let hist = JSON.parse(localStorage.getItem(KEY) || '[]');
  if (hist.length === 0) hist.push(BASELINE_PROJECTION, v);
  else if (hist[hist.length-1] !== v) hist.push(v);
  if (hist.length > 16) hist = hist.slice(-16);
  localStorage.setItem(KEY, JSON.stringify(hist));
  drawSparkline(hist);
}

function drawSparkline(hist) {
  const svg = document.getElementById('pillSpark');
  if (!svg || hist.length < 2) return;
  const W = 36, H = 12, min = Math.min(...hist), max = Math.max(...hist), rng = max - min || 1;
  const pts = hist.map((v,i) => (i/(hist.length-1)*W).toFixed(1) + ',' + (H-2-(v-min)/rng*(H-4)).toFixed(1)).join(' ');
  svg.querySelector('polyline').setAttribute('points', pts);
}

function renderTrajectory(currentTotal) {
  const el = document.getElementById('trajectory');
  if (!el) return;
  const steps = [
    { lbl:'Today',            val:currentTotal,                                           delta:0,   kind:'now' },
    { lbl:'+ Retain counsel', val:Math.min(CEILING_PROJECTION, currentTotal+180),          delta:180, kind:'next' },
    { lbl:'+ Top 5 evidence', val:Math.min(CEILING_PROJECTION, currentTotal+180+295),      delta:295, kind:'next' },
    { lbl:'+ Claim filed',    val:Math.min(CEILING_PROJECTION, currentTotal+180+295+100),  delta:100, kind:'next' },
    { lbl:'Trial-ready',      val:CEILING_PROJECTION,                                      delta:0,   kind:'ceiling' },
  ];
  const details = [
    { l:'Where you stand today',    m:'Current projection of $' + currentTotal + 'k based on completed evidence and counsel posture.', v:'$' + currentTotal + 'k' },
    { l:'Retain counsel',           m:"One signed retainer flips the AG's posture. Press-capable counsel (Thomas Harding) maximizes the silence premium.", v:'+$180k' },
    { l:'Complete top 5 evidence',  m:'BWC footage, therapist letter (PTSD + causation), ATIP officer notebooks, E-Comm 911 audio, hospital discharge - top leverage items.', v:'+$295k' },
    { l:'Claim filed',              m:'Filing converts pre-litigation soft leverage to live procedural pressure. AG must engage and consider discovery exposure.', v:'+$100k' },
    { l:'Trial-ready evidence',     m:'Full pleadings, expert reports (forensic psych + vocational economist). Trial threat is now credible.', v:'$' + CEILING_PROJECTION/1000 + 'M ceiling' },
  ];

  const stepsHtml = steps.map((s,i) => {
    const left = (i / (steps.length-1)) * 100;
    return '<div class="traj-step ' + (s.kind==='now'?'now':'') + '" data-i="' + i + '" style="left:' + left + '%">' +
      '<div class="val">$' + s.val + 'k</div>' +
      (s.delta > 0 ? '<div class="traj-delta">+$' + s.delta + 'k</div>' : '') +
      '<div class="dot"></div><div class="lbl">' + s.lbl + '</div></div>';
  }).join('');

  el.innerHTML =
    '<div class="section-hd"><div class="lbl"><b>Trajectory</b> - what each next move adds</div><div class="hint">tap a step to focus</div></div>' +
    '<div class="traj-card">' +
    '<div class="traj-track" id="trajTrack"><div class="traj-line"></div>' + stepsHtml + '</div>' +
    '<div class="traj-detail">' +
    '<div class="det-l" id="trajDetailLbl">Focus</div>' +
    '<div class="det-m" id="trajDetailMsg">' + details[1].m + '</div>' +
    '<div class="det-r" id="trajDetailVal">' + details[1].v + '</div>' +
    '</div></div>';

  el.querySelectorAll('.traj-step').forEach(step => {
    step.addEventListener('click', () => {
      const i = parseInt(step.dataset.i);
      document.getElementById('trajDetailLbl').textContent = details[i].l;
      document.getElementById('trajDetailMsg').textContent = details[i].m;
      document.getElementById('trajDetailVal').textContent = details[i].v;
      el.querySelectorAll('.traj-step').forEach(s => s.classList.remove('focus'));
      step.classList.add('focus');
      const pv = Math.min(100, ((steps[i].val - BASELINE_PROJECTION) / (CEILING_PROJECTION - BASELINE_PROJECTION)) * 100);
      const fill = document.querySelector('.lev-bar-fill'), marker = document.querySelector('.lev-bar-marker');
      if (fill) fill.style.width = pv + '%';
      if (marker) marker.style.left = pv + '%';
      clearTimeout(window.__trajT);
      if (i !== 0) window.__trajT = setTimeout(renderLeverage, 2400);
      else renderLeverage();
    });
  });
}

// ===== RENDER =====

(function(){
  const now = new Date();
  document.getElementById('todayStr').textContent = now.toLocaleDateString('en-US',{month:'long',day:'numeric',year:'numeric'}).toUpperCase();
})();

(function(){
  const incident = new Date('2023-08-01').getTime();
  const expired  = new Date('2025-08-01').getTime();
  const ultimate = new Date('2038-08-01').getTime();
  const now = Date.now();
  const total = ultimate - incident;
  const pNow = ((now - incident) / total) * 100;
  const pExp = ((expired - incident) / total) * 100;
  const daysSince = Math.floor((now - incident) / 86400000);
  const daysToUlt = Math.floor((ultimate - now) / 86400000);

  document.getElementById('daysOut').textContent = daysToUlt.toLocaleString() + ' DAYS TO ULTIMATE';

  const nowClamped = Math.max(8, Math.min(92, pNow));
  const nowRow = document.getElementById('clockNowRow');
  const nowLabel = document.createElement('div');
  nowLabel.className = 'clock-now-label';
  nowLabel.style.cssText = 'left:' + nowClamped + '%;bottom:0';
  const whatEl = document.createElement('div'); whatEl.className = 'what'; whatEl.textContent = 'Today - ' + daysSince.toLocaleString() + ' days in';
  const whenEl = document.createElement('div'); whenEl.className = 'when'; whenEl.textContent = 'May 17, 2026';
  nowLabel.appendChild(whatEl); nowLabel.appendChild(whenEl);
  nowRow.appendChild(nowLabel);

  const therapyStart = new Date('2026-05-01').getTime();
  const pTherapy = ((therapyStart - incident) / total) * 100;
  const curve = [];
  for (let i = 0; i <= 80; i++) {
    const x = (i/80)*100;
    const t = x < pTherapy ? x/pTherapy : (x-pTherapy)/(100-pTherapy);
    const y = x < pTherapy ? 0.45+0.55*t : 1.0-0.85*t*t;
    curve.push([x,y]);
  }
  const W=1000, H=70;
  const pathD = curve.map((p,i)=>(i===0?'M':'L')+(p[0]/100*W).toFixed(1)+','+(((1-p[1])*(H-4)+2)).toFixed(1)).join(' ');
  const areaD = pathD + ' L' + W + ',' + H + ' L0,' + H + ' Z';
  const curveYpx = (1-(curve.find(p=>p[0]>=pNow)||curve[curve.length-1])[1])*H;
  const stemHeight = (96-16)-curveYpx;

  const track = document.getElementById('clockTrack');
  track.innerHTML =
    '<svg class="clock-decay-svg" viewBox="0 0 ' + W + ' ' + H + '" preserveAspectRatio="none">' +
    '<defs><linearGradient id="decayGrad" x1="0" x2="0" y1="0" y2="1">' +
    '<stop offset="0%" stop-color="var(--warn)" stop-opacity="0.32"/>' +
    '<stop offset="100%" stop-color="var(--warn)" stop-opacity="0"/>' +
    '</linearGradient></defs>' +
    '<path d="' + areaD + '" fill="url(#decayGrad)"/>' +
    '<path d="' + pathD + '" fill="none" stroke="var(--warn)" stroke-width="1.4" vector-effect="non-scaling-stroke" opacity="0.75"/>' +
    '</svg>' +
    '<div class="clock-line"></div>' +
    '<div class="clock-segment expired" style="left:0%;width:' + pExp + '%"></div>' +
    '<div class="clock-segment runway" style="left:' + pExp + '%;width:' + (pNow-pExp) + '%"></div>' +
    '<div class="clock-tick t-incident" style="left:0%;transform:translateX(-50%)"><div class="dot"></div></div>' +
    '<div class="clock-tick t-expired" style="left:' + pExp + '%;transform:translateX(-50%)"><div class="dot"></div></div>' +
    '<div class="clock-tick t-now" style="left:' + pNow + '%;transform:translateX(-50%)"><div class="stem" style="height:' + Math.max(0,stemHeight).toFixed(1) + 'px"></div><div class="dot"></div></div>' +
    '<div class="clock-tick t-ultimate" style="left:100%;transform:translateX(-50%)"><div class="dot"></div></div>';

  const labels = document.getElementById('clockLabels');
  const tight = pExp < 18;
  if (tight) {
    labels.innerHTML =
      '<div class="clock-label left exp"><div class="when">Aug 2023 to Aug 2025</div><div class="what">Incident to Basic expired</div></div>' +
      '<div class="clock-label right"><div class="when">Aug 2038</div><div class="what">Ultimate</div></div>';
  } else {
    labels.innerHTML =
      '<div class="clock-label left"><div class="when">Aug 2023</div><div class="what">Incident</div></div>' +
      '<div class="clock-label exp mid" style="left:' + pExp + '%;transform:translateX(-50%)"><div class="when">Aug 2025</div><div class="what">Basic expired</div></div>' +
      '<div class="clock-label right"><div class="when">Aug 2038</div><div class="what">Ultimate</div></div>';
  }
})();

function renderGrounds(containerId, suffix) {
  const c = document.getElementById(containerId);
  while (c.firstChild) c.removeChild(c.firstChild);
  const data = webActiveCase === 'rcmp' ? GROUNDS : FAMILY_GROUNDS;
  const maxHigh = webActiveCase === 'rcmp' ? 600 : 200;
  data.forEach(g => {
    const w = document.createElement('div');
    w.className = 'ground';
    w.dataset.id = g.id + suffix;
    const pct = (g.high / maxHigh) * 100;

    const hd = document.createElement('div'); hd.className = 'ground-hd';
    const n = document.createElement('div'); n.className = 'ground-n serif'; n.textContent = g.n;
    const info = document.createElement('div');
    const title = document.createElement('div'); title.className = 'ground-title serif'; title.textContent = g.title;
    const sec = document.createElement('div'); sec.className = 'ground-sec'; sec.textContent = g.sec;
    info.appendChild(title); info.appendChild(sec);
    const val = document.createElement('div'); val.className = 'ground-val tnum'; val.textContent = g.val;
    const grade = document.createElement('div'); grade.className = 'ground-grade g-' + g.grade; grade.textContent = g.grade;
    hd.appendChild(n); hd.appendChild(info); hd.appendChild(val); hd.appendChild(grade);

    const mag = document.createElement('div'); mag.className = 'ground-mag';
    const fill = document.createElement('div'); fill.className = 'ground-mag-fill';
    fill.dataset.w = pct.toFixed(1);
    fill.style.background = 'var(--grade-' + g.grade.toLowerCase() + ')';
    mag.appendChild(fill);

    const body = document.createElement('div'); body.className = 'ground-body';
    const inner = document.createElement('div'); inner.className = 'ground-inner';
    const desc = document.createElement('div'); desc.className = 'ground-desc'; desc.textContent = g.desc;
    const cite = document.createElement('div'); cite.className = 'ground-cite'; cite.textContent = g.cite;
    inner.appendChild(desc);
    if (g.risk) { const riskEl = document.createElement('div'); riskEl.className = 'ground-risk'; riskEl.textContent = g.risk; inner.appendChild(riskEl); }
    inner.appendChild(cite); body.appendChild(inner);

    w.appendChild(hd); w.appendChild(mag); w.appendChild(body);
    c.appendChild(w);

    w.addEventListener('click', () => {
      const open = w.classList.contains('open');
      c.querySelectorAll('.ground').forEach(x => x.classList.remove('open'));
      if (!open) {
        w.classList.add('open');
        w.querySelector('.ground-mag-fill').style.width = w.querySelector('.ground-mag-fill').dataset.w + '%';
      }
    });
  });
}
renderGrounds('grounds-case', '');
renderGrounds('grounds-money', '2');

function renderScenarios() {
  const c = document.getElementById('scenarios');
  while (c.firstChild) c.removeChild(c.firstChild);
  const data = webActiveCase === 'rcmp' ? SCENARIOS : FAMILY_SCENARIOS;
  data.forEach((s,i) => {
    const d = document.createElement('div'); d.className = 'scen';
    const row = document.createElement('div'); row.className = 'scen-row';
    const left = document.createElement('div');
    const name = document.createElement('div'); name.className = 'scen-name serif'; name.textContent = s.name;
    const desc = document.createElement('div'); desc.className = 'scen-desc'; desc.textContent = s.desc;
    left.appendChild(name); left.appendChild(desc);
    const right = document.createElement('div'); right.className = 'scen-right';
    const amt = document.createElement('div'); amt.className = 'scen-amt tnum'; amt.style.color = s.color; amt.textContent = s.amt;
    const pct = document.createElement('div'); pct.className = 'scen-pct'; pct.textContent = s.pct + '% probability';
    right.appendChild(amt); right.appendChild(pct);
    row.appendChild(left); row.appendChild(right);
    const barTrack = document.createElement('div'); barTrack.className = 'bar-track';
    const barFill = document.createElement('div'); barFill.className = 'bar-fill';
    barFill.dataset.w = s.pct; barFill.style.background = s.color; barFill.style.transitionDelay = (i*100) + 'ms';
    barTrack.appendChild(barFill);
    d.appendChild(row); d.appendChild(barTrack);
    c.appendChild(d);
  });
}
renderScenarios();

let stackMode = 'strong';
function renderStack() {
  const c = document.getElementById('stackRows');
  c.innerHTML = '';
  const heads = webActiveCase === 'rcmp' ? STACK_HEADS : FAMILY_STACK_HEADS;
  const total = heads.reduce((s,h) => s + (stackMode==='strong'?h.high:h.low), 0);
  const max = Math.max(...heads.map(h => stackMode==='strong'?h.high:h.low));
  document.getElementById('stackTot').textContent = '$' + (total/1000).toFixed(2) + 'M';
  heads.forEach(h => {
    const v = stackMode==='strong' ? h.high : h.low;
    const pct = (v/max)*100;
    const r = document.createElement('div'); r.className = 'stack-row';
    const badge = document.createElement('div'); badge.className = 'badge g-' + h.grade; badge.textContent = h.grade;
    const mid = document.createElement('div'); mid.className = 'mid';
    const info = document.createElement('div');
    const lbl = document.createElement('div'); lbl.className = 'label'; lbl.textContent = h.label;
    const sub = document.createElement('div'); sub.className = 'sub'; sub.textContent = h.sub;
    info.appendChild(lbl); info.appendChild(sub);
    const meter = document.createElement('div'); meter.className = 'meter';
    const mFill = document.createElement('div'); mFill.dataset.w = pct.toFixed(1); mFill.style.background = 'var(--grade-' + h.grade.toLowerCase() + ')';
    meter.appendChild(mFill); mid.appendChild(info); mid.appendChild(meter);
    const amtEl = document.createElement('div'); amtEl.className = 'amt tnum'; amtEl.textContent = '$' + (v<1000 ? v+'k' : (v/1000).toFixed(2)+'M');
    r.appendChild(badge); r.appendChild(mid); r.appendChild(amtEl);
    c.appendChild(r);
  });
  requestAnimationFrame(() => requestAnimationFrame(() => {
    c.querySelectorAll('.meter > div').forEach(b => b.style.width = b.dataset.w + '%');
  }));
}
renderStack();
document.querySelectorAll('.stack-toggle button').forEach(b => {
  b.addEventListener('click', () => {
    stackMode = b.dataset.m;
    document.querySelectorAll('.stack-toggle button').forEach(x => x.classList.remove('active'));
    b.classList.add('active');
    renderStack();
  });
});

(function(){
  const c = document.getElementById('scaleBands');
  SCALE.forEach(band => {
    const d = document.createElement('div'); d.className = 'scale-band';
    const hd = document.createElement('div'); hd.className = 'scale-band-hd';
    const lbl = document.createElement('div'); lbl.className = 'lbl'; lbl.textContent = band.band;
    const max = document.createElement('div'); max.className = 'max';
    max.textContent = 'scale: $0 to $' + (band.max>=1000 ? (band.max/1000).toFixed(1)+'M' : band.max+'k');
    hd.appendChild(lbl); hd.appendChild(max); d.appendChild(hd);

    const track = document.createElement('div'); track.className = 'scale-track';
    const line = document.createElement('div'); line.className = 'line'; track.appendChild(line);
    band.marks.forEach(m => {
      const mk = document.createElement('div'); mk.className = 'scale-mark' + (m.isThis?' this':'');
      mk.style.left = (m.k / band.max * 100) + '%';
      const dot = document.createElement('div'); dot.className = 'dot';
      const mlbl = document.createElement('div'); mlbl.className = 'lbl'; mlbl.textContent = m.lbl;
      mk.appendChild(dot); mk.appendChild(mlbl); track.appendChild(mk);
    });
    d.appendChild(track);

    const list = document.createElement('div'); list.className = 'scale-list';
    band.rows.forEach(row => {
      const rowEl = document.createElement('div'); rowEl.className = 'row';
      const name = document.createElement('div'); name.className = 'name';
      const nameText = document.createTextNode(row.name + ' ');
      const yr = document.createElement('span'); yr.className = 'yr'; yr.textContent = '- ' + row.yr + ' - ' + row.note;
      name.appendChild(nameText); name.appendChild(yr);
      const v = document.createElement('div'); v.className = 'v tnum'; v.textContent = row.v;
      rowEl.appendChild(name); rowEl.appendChild(v); list.appendChild(rowEl);
    });
    d.appendChild(list);
    c.appendChild(d);
  });
})();

function renderLawyers() {
  const c = document.getElementById('lawyers');
  while (c.firstChild) c.removeChild(c.firstChild);
  const data = webActiveCase === 'rcmp' ? LAWYERS : FAMILY_LAWYERS;
  data.forEach(L => {
    const isPriority = L.id === 'thomas-harding' || L.id === 'neil-chantler';
    const d = document.createElement('div'); d.className = 'lawyer' + (isPriority ? ' priority' : ''); d.dataset.lawyerId = L.id;

    const av = document.createElement('div'); av.className = 'lawyer-av'; av.textContent = L.init;
    const body = document.createElement('div'); body.className = 'lawyer-body';
    const nameRow = document.createElement('div'); nameRow.className = 'lawyer-name-row';
    const name = document.createElement('div'); name.className = 'lawyer-name'; name.textContent = L.name;
    const fits = document.createElement('div'); fits.className = 'fit-dots fit-' + L.fit; fits.title = 'Case-fit ' + L.fit + '/5';
    fits.textContent = '●'.repeat(L.fit) + '○'.repeat(5-L.fit);
    nameRow.appendChild(name); nameRow.appendChild(fits);
    const sub = document.createElement('div'); sub.className = 'lawyer-sub'; sub.textContent = L.sub;
    const tags = document.createElement('div'); tags.className = 'lawyer-tags';
    L.tags.forEach(t => { const tg = document.createElement('span'); tg.className = 'tag ' + (t.c||''); tg.textContent = t.t; tags.appendChild(tg); });
    const chip = document.createElement('span'); chip.className = 'tag status ' + L.status; chip.dataset.status = L.status; chip.textContent = STATUS_LABEL[L.status];
    tags.appendChild(chip);
    body.appendChild(nameRow); body.appendChild(sub); body.appendChild(tags);

    const actions = document.createElement('div'); actions.className = 'lawyer-actions';
    L.contacts.forEach(ct => {
      const a = document.createElement('a'); a.className = 'contact' + (ct.primary?' primary':''); a.href = ct.href;
      const ic = document.createElement('span'); ic.className = 'ic'; ic.textContent = ct.kind;
      const lbl = document.createElement('span'); lbl.textContent = ct.label;
      a.appendChild(ic); a.appendChild(lbl); actions.appendChild(a);
    });

    d.appendChild(av); d.appendChild(body); d.appendChild(actions);
    c.appendChild(d);

    chip.addEventListener('click', e => {
      e.stopPropagation();
      const cur = chip.dataset.status;
      const next = STATUS_CYCLE[(STATUS_CYCLE.indexOf(cur)+1)%STATUS_CYCLE.length];
      chip.dataset.status = next;
      chip.className = 'tag status ' + next;
      chip.textContent = STATUS_LABEL[next];
      _lawyerStatuses[L.id] = next;
      if (_userId && webActiveCase === 'rcmp') _sb.from('brief_lawyer_status').upsert({ user_id:_userId, lawyer_id:L.id, status:next });
      if (webActiveCase === 'rcmp') renderLeverage();
    });
  });
}
renderLawyers();

function renderTimeline() {
  const c = document.getElementById('timeline');
  while (c.firstChild) c.removeChild(c.firstChild);
  const data = webActiveCase === 'rcmp' ? TIMELINE : FAMILY_TIMELINE;
  data.forEach((t,i) => {
    const d = document.createElement('div'); d.className = 'tl-item';
    const when = document.createElement('div'); when.className = 'tl-when'; when.textContent = t.when;
    const rail = document.createElement('div'); rail.className = 'tl-rail';
    const dot = document.createElement('div'); dot.className = 'tl-dot ' + (t.state||'');
    rail.appendChild(dot);
    if (i < data.length-1) { const line = document.createElement('div'); line.className = 'tl-line'; rail.appendChild(line); }
    const body = document.createElement('div'); body.className = 'tl-body';
    const title = document.createElement('div'); title.className = 'tl-title serif'; title.textContent = t.title;
    const desc = document.createElement('div'); desc.className = 'tl-desc'; desc.textContent = t.desc;
    body.appendChild(title); body.appendChild(desc);
    d.appendChild(when); d.appendChild(rail); d.appendChild(body);
    c.appendChild(d);
  });
}
renderTimeline();

const CL_STORE = 'brief.v3.checklist';
function renderChecklist() {
  const c = document.getElementById('checklist');
  while (c.firstChild) c.removeChild(c.firstChild);
  const cl = getActiveChecklist();
  const store = getClStore();
  const saved = JSON.parse(localStorage.getItem(store) || '{}');
  cl.forEach(it => { if (saved[it.i] !== undefined) it.done = saved[it.i]; });
  cl.sort((a, b) => (a.done === b.done) ? b.lev - a.lev : a.done ? 1 : -1);
  cl.forEach(it => {
    const d = document.createElement('div'); d.className = 'cl-item'; d.dataset.i = it.i;
    const box = document.createElement('div'); box.className = 'cl-box' + (it.done?' done':'');
    const lbl = document.createElement('div'); lbl.className = 'cl-label' + (it.done?' done':''); lbl.textContent = it.label;
    const lev = document.createElement('div'); lev.className = 'cl-lev'; lev.textContent = '+$' + it.lev + 'k';
    if (it.done) { lev.style.opacity = '0.4'; lev.style.textDecoration = 'line-through'; }
    const pri = document.createElement('div'); pri.className = 'cl-pri ' + it.pri; pri.textContent = it.pri;
    d.appendChild(box); d.appendChild(lbl); d.appendChild(lev); d.appendChild(pri);
    c.appendChild(d);
    d.addEventListener('click', () => {
      it.done = !it.done;
      const s = JSON.parse(localStorage.getItem(store) || '{}');
      s[it.i] = it.done;
      localStorage.setItem(store, JSON.stringify(s));
      box.classList.toggle('done', it.done);
      lbl.classList.toggle('done', it.done);
      lev.style.opacity = it.done ? '0.4' : '';
      lev.style.textDecoration = it.done ? 'line-through' : '';
      if (_userId && webActiveCase === 'rcmp') _sb.from('brief_checklist').upsert({ user_id:_userId, item_index:parseInt(it.i), completed:it.done });
      updateClProg();
      if (webActiveCase === 'rcmp') renderLeverage();
    });
  });
  updateClProg();
}
renderChecklist();

function updateClProg() {
  const cl = getActiveChecklist();
  const done = cl.filter(x => x.done).length;
  document.getElementById('clCount').textContent = done;
  document.getElementById('clTotal').textContent = cl.length;
  document.getElementById('clBar').style.width = (done/cl.length*100) + '%';
}

function renderJournalEntries(entries) {
  const list = document.getElementById('journalList');
  if (!list) return;
  while (list.firstChild) list.removeChild(list.firstChild);
  entries.forEach(e => {
    const d = document.createElement('div'); d.className = 'j-entry';
    const dt = new Date(e.date+'T12:00:00').toLocaleDateString('en-US',{month:'short',day:'numeric',year:'numeric'}).toUpperCase();
    const when = document.createElement('div'); when.className = 'when'; when.textContent = dt;
    const what = document.createElement('div'); what.className = 'what serif'; what.textContent = e.text;
    d.appendChild(when); d.appendChild(what);
    list.appendChild(d);
  });
}

const J_STORE = 'brief.v3.journal';
(function(){
  const saved = JSON.parse(localStorage.getItem(J_STORE) || '[]');
  const map = {};
  JOURNAL_SEED.forEach(e => map[e.date] = e);
  saved.forEach(e => map[e.date] = e);
  renderJournalEntries(Object.values(map).sort((a,b) => b.date.localeCompare(a.date)));

  const btn = document.getElementById('jAddBtn');
  const form = document.getElementById('jForm');
  const dateI = document.getElementById('jDate');
  const txtI = document.getElementById('jText');
  const today = new Date().toISOString().slice(0,10);
  dateI.value = today; dateI.max = today;

  btn.addEventListener('click', () => { form.classList.toggle('open'); if (form.classList.contains('open')) txtI.focus(); });
  document.getElementById('jCancel').addEventListener('click', () => { form.classList.remove('open'); txtI.value = ''; });
  document.getElementById('jSave').addEventListener('click', () => {
    const txt = txtI.value.trim(); if (!txt) return;
    const s = JSON.parse(localStorage.getItem(J_STORE) || '[]');
    s.push({ date:dateI.value, text:txt });
    localStorage.setItem(J_STORE, JSON.stringify(s));
    const m = {};
    JOURNAL_SEED.forEach(e => m[e.date] = e);
    s.forEach(e => m[e.date] = e);
    renderJournalEntries(Object.values(m).sort((a,b) => b.date.localeCompare(a.date)));
    txtI.value = ''; form.classList.remove('open');
  });
})();

function animateBars() {
  document.querySelectorAll('#scenarios .bar-fill').forEach(b => b.style.width = b.dataset.w + '%');
}
document.querySelectorAll('.tab-btn').forEach((b,idx,all) => {
  b.setAttribute('role','tab');
  b.setAttribute('tabindex', b.classList.contains('active') ? '0' : '-1');
  b.addEventListener('click', () => {
    all.forEach(x => { x.classList.remove('active'); x.setAttribute('tabindex','-1'); });
    document.querySelectorAll('.tab-panel').forEach(x => x.classList.remove('active'));
    b.classList.add('active'); b.setAttribute('tabindex','0');
    document.getElementById('panel-' + b.dataset.tab).classList.add('active');
    if (b.dataset.tab === 'money') setTimeout(animateBars, 80);
  });
  b.addEventListener('keydown', e => {
    if (e.key === 'ArrowRight' || e.key === 'ArrowLeft') {
      e.preventDefault();
      const n = (idx + (e.key === 'ArrowRight' ? 1 : -1) + all.length) % all.length;
      all[n].focus(); all[n].click();
    }
  });
});

document.querySelectorAll('.ground').forEach(g => {
  g.setAttribute('tabindex','0'); g.setAttribute('role','button');
  g.addEventListener('keydown', e => { if (e.key==='Enter'||e.key===' ') { e.preventDefault(); g.click(); } });
});

(function(){
  const mq = window.matchMedia('(prefers-color-scheme: light)');
  let mode = 'auto';
  function applySystem() { if (mode === 'auto') document.body.dataset.theme = mq.matches ? 'white' : 'dark'; }
  window.__setTheme = function(m) { mode = m; if (m === 'auto') applySystem(); else document.body.dataset.theme = m; };
  applySystem();
  if (mq.addEventListener) mq.addEventListener('change', applySystem);
})();

const TWEAKS = { theme:'auto', accent:'red', hero:100, density:'comfortable', annot:true, decay:true };
(function(){
  const panel = document.getElementById('twPanel');
  function apply(t) {
    window.__setTheme(t.theme);
    document.body.dataset.accent = t.accent;
    document.body.dataset.density = t.density;
    document.body.dataset.annot = t.annot ? 'on' : 'off';
    document.body.dataset.decay = t.decay ? 'on' : 'off';
    document.documentElement.style.setProperty('--hero-scale', (t.hero/100).toFixed(2));
    document.getElementById('twHeroVal').textContent = (t.hero/100).toFixed(2) + 'x';
    panel.querySelectorAll('.tw-seg[data-key="theme"] button').forEach(b => b.classList.toggle('active', b.dataset.v === t.theme));
    panel.querySelectorAll('.tw-swatches[data-key="accent"] button').forEach(b => b.classList.toggle('active', b.dataset.v === t.accent));
    panel.querySelectorAll('.tw-seg[data-key="density"] button').forEach(b => b.classList.toggle('active', b.dataset.v === t.density));
    document.getElementById('twHero').value = t.hero;
    document.getElementById('twAnnot').checked = t.annot;
    document.getElementById('twDecay').checked = t.decay;
  }
  function set(patch) { Object.assign(TWEAKS, patch); apply(TWEAKS); }
  panel.querySelectorAll('.tw-seg button').forEach(b => b.addEventListener('click', () => set({ [b.parentElement.dataset.key]: b.dataset.v })));
  panel.querySelectorAll('.tw-swatches button').forEach(b => b.addEventListener('click', () => set({ [b.parentElement.dataset.key]: b.dataset.v })));
  document.getElementById('twHero').addEventListener('input', e => set({ hero: parseInt(e.target.value) }));
  document.getElementById('twAnnot').addEventListener('change', e => set({ annot: e.target.checked }));
  document.getElementById('twDecay').addEventListener('change', e => set({ decay: e.target.checked }));
  document.getElementById('twClose').addEventListener('click', () => { panel.hidden = true; });
  document.addEventListener('keydown', e => { if (e.shiftKey && e.key === 'T') panel.hidden = !panel.hidden; });
  const tweaksBtn = document.getElementById('tweaksBtn');
  if (tweaksBtn) tweaksBtn.addEventListener('click', () => { panel.hidden = !panel.hidden; });
  apply(TWEAKS);
})();

const scriptEl = document.getElementById('scriptText');
if (scriptEl) scriptEl.textContent = CALL_SCRIPT;
document.getElementById('copyScript').addEventListener('click', function() {
  navigator.clipboard.writeText(document.getElementById('scriptText').textContent).then(() => {
    this.textContent = 'Copied'; this.classList.add('copied');
    setTimeout(() => { this.textContent = 'Copy'; this.classList.remove('copied'); }, 1800);
  });
});

// ===== SUPABASE SYNC (called after auth) =====
function loadChecklistFromDB() {
  if (!_sb) return;
  _sb.from('brief_checklist').select('*').then(res => {
    (res.data||[]).forEach(r => {
      const it = CHECKLIST.find(x => x.i === String(r.item_index));
      if (it) it.done = r.completed;
    });
    const s = {};
    CHECKLIST.forEach(it => s[it.i] = it.done);
    localStorage.setItem(CL_STORE, JSON.stringify(s));
    document.querySelectorAll('.cl-item').forEach(row => {
      const it = CHECKLIST.find(x => x.i === row.dataset.i);
      if (!it) return;
      row.querySelector('.cl-box').classList.toggle('done', it.done);
      row.querySelector('.cl-label').classList.toggle('done', it.done);
      const lev = row.querySelector('.cl-lev');
      if (lev) { lev.style.opacity = it.done ? '0.4' : ''; lev.style.textDecoration = it.done ? 'line-through' : ''; }
    });
    updateClProg();
    if (webActiveCase === 'rcmp') renderLeverage();
  });
}

function loadLawyerStatusFromDB() {
  if (!_sb) return;
  _sb.from('brief_lawyer_status').select('*').then(res => {
    (res.data||[]).forEach(r => { _lawyerStatuses[r.lawyer_id] = r.status; });
    document.querySelectorAll('.lawyer[data-lawyer-id]').forEach(card => {
      const id = card.dataset.lawyerId;
      const status = _lawyerStatuses[id] || (LAWYERS.find(l => l.id === id) || {}).status || 'none';
      const chip = card.querySelector('.tag.status');
      if (!chip) return;
      chip.dataset.status = status;
      chip.className = 'tag status ' + status;
      chip.textContent = STATUS_LABEL[status];
    });
    if (webActiveCase === 'rcmp') renderLeverage();
  });
}

function initData() {
  loadChecklistFromDB();
  loadLawyerStatusFromDB();
}

renderLeverage();

// ===== Deep links =====
// ?pin=7743 skips the Supabase auth overlay (identical to post-login loadAndShow).
// ?case=rcmp|family selects the active case on load.
(function() {
  var params = new URLSearchParams(location.search);
  if (params.get('pin') === '7743') loadAndShow();
  var qc = params.get('case');
  if (qc && (qc === 'rcmp' || qc === 'family')) setActiveCase(qc);
})();

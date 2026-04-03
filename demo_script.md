# GigShield Hackathon Demo Script (2 Minutes)

## Pre-requisites & Setup
- **Tools/Screens Needed:** Screen recording of Flutter App running on Android emulator, Backend terminal window visible for `POST /events/trigger`, Code editor/Dashboard to show Trust Score.
- **Background Music Mood:** Upbeat, fast-paced lo-fi or subtle electronic (creates a sense of seamless tech solving a stressful problem).

---

## Shot-by-Shot Breakdown

### [0:00–0:20] — Problem hook
- **Voiceover:** "5 million delivery workers. One bad monsoon week. Zero income protection."
- **Show:** Cinematic B-roll of rain or a map of Mumbai flooded with delivery partner pins.

### [0:20–0:45] — Worker onboarding
- **Voiceover:** "Registration takes 60 seconds. Policy activates in 24 hours."
- **Show:** Screen recording of Flutter app (Screen 1). Ravi Kumar registers, enters "Andheri East" (400053) pin code, and uploads his Swiggy ID. Taps "Activate".

### [0:45–1:10] — Event trigger
- **Voiceover:** "Our system polls weather data every 5 minutes. The moment thresholds are crossed, claims auto-trigger."
- **Show:** Terminal window running curl or FastAPI swagger calling `POST /events/trigger` with `rain=52mm`, `pin_code=400053`.
- **Show:** Flutter App (Screen 3) receives the dynamic push alert "Heavy Rain Detected".

### [1:10–1:35] — Fraud check passing
- **Voiceover:** "Our 5-signal Trust Score engine verifies the worker in real time. No forms. No calls."
- **Show:** Quick glimpse of ML Backend logs or simple dashboard showing `Trust Score = 87 → Tier 1 Auto-Approved`.

### [1:35–2:00] — Payout confirmation
- **Voiceover:** "₹900 lands in Ravi's account in under 10 minutes. That's GigShield."
- **Show:** Flutter App transitions to Screen 4 (Payout Confirmation). Green checkmark animation with "₹900 sent to your UPI". 
- **End card:** Fade to GigShield logo + tagline: "Instant protection. Zero friction."

# GigShield 🛡️

### Parametric Income Insurance for Food Delivery Workers

> Automatically protecting Zomato & Swiggy delivery partners from income loss caused by rain, floods, pollution, and curfews — no forms, no calls, just instant payouts.

---

## Table of Contents
1. [The Problem](#1-the-problem)
2. [Our Solution](#2-our-solution)
3. [Who We're Building For](#3-who-were-building-for)
4. [How the Platform Works](#4-how-the-platform-works)
5. [Weekly Premium Model](#5-weekly-premium-model)
6. [AI & ML Strategy](#6-ai--ml-strategy)
7. [Adversarial Defense & Anti-Spoofing Strategy](#7-adversarial-defense--anti-spoofing-strategy)
8. [Tech Stack](#8-tech-stack)
9. [System Architecture](#9-system-architecture)
10. [Roadmap](#10-roadmap)
11. [Business Model](#11-business-model)
12. [Demo Video](#12-demo-video)

---

## 1. The Problem

There are over **5 million active food delivery partners** working for Zomato and Swiggy across India. They earn ₹400–₹800 per day — entirely dependent on being able to ride.

When external disruptions hit, their income drops to zero:

| Disruption | Impact |
|-----------|--------|
| Heavy rainfall (>50mm/hr) | Roads flood, orders cancel, riders stay home |
| Extreme heat (>45°C) | Health risk, platform order volumes drop |
| Hazardous pollution (AQI >400) | Unsafe to ride, city advisories issued |
| Curfew / Section 144 | Complete delivery shutdown |
| Flooding | Zone-level delivery impossible |

These workers have no employer, no paid leave, no savings buffer, and no insurance product designed for them. **One bad monsoon week can push a family into debt.**

Traditional insurance fails them for three reasons:
- Requires manual claim filing — too complex for daily-wage workers
- Covers health or vehicle damage, not lost income
- Monthly premiums do not match weekly earning cycles

---

## 2. Our Solution

**GigShield is a parametric income insurance platform built specifically for food delivery workers.**

**Parametric** means: the claim triggers automatically based on verified external event data — not a manual request from the worker.

### How it works in one line:
> A delivery partner pays ₹40/week. When our system detects heavy rain in their delivery zone, it sends them compensation in under 10 minutes. They do not fill a form. They do not call anyone. It just works.

### What makes GigShield different:
- **Fully automated** — no human in the claims loop
- **Hyper-local** — risk and triggers calculated at pin-code level, not city level
- **Fraud-proof** — multi-signal Trust Score engine prevents GPS spoofing attacks
- **Fair** — genuine workers never get penalized for network drops during storms

---

## 3. Who We're Building For

### Primary Persona: Food Delivery Partners — Zomato & Swiggy

**Why this persona specifically:**
- 5 million+ active delivery partners in India
- 100% dependent on weather and open roads for income
- Already own smartphones with GPS — critical for our verification system
- Income is per-order and highly predictable — makes payout calculation straightforward
- High geographic clustering in cities — makes our fraud detection more powerful
- Weekly income cycle matches our weekly premium model perfectly

**Worker profile:**
- Age: 20–35
- Monthly income: ₹12,000–₹25,000
- Works: 8–12 hours/day, 6 days/week
- Device: Android smartphone (budget to mid-range)
- Preferred payment: UPI (PhonePe / GPay)

**Target cities for Phase 2:** Mumbai, Delhi, Bengaluru, Chennai, Hyderabad

---

## 4. How the Platform Works

```
Worker registers → Risk profiled → Weekly policy issued →
Events monitored → Disruption detected → Anti-fraud check →
Claim auto-triggered → Payout sent in under 10 minutes
```

### Step 1 — Worker Onboarding
- Worker signs up via web portal or mobile app
- Enters: name, phone number, delivery zone (pin code), platform, average weekly earnings
- Uploads: Zomato/Swiggy partner ID for identity verification
- System creates a digital profile with a Trust Wallet

### Step 2 — AI Risk Profiling
Our Risk Engine analyzes the worker's delivery zone:
- 3 years of historical rainfall data (IMD)
- Monthly AQI averages (AQICN)
- Frequency of curfews and civic disruptions
- Historical claim rates per pin code

Output: a **Risk Score (0–100)** per worker, recalculated every week.

### Step 3 — Weekly Premium Calculation
Dynamic, zone-specific pricing:

| Zone Type | Example Location | Weekly Premium |
|-----------|-----------------|----------------|
| High risk (flood-prone) | Worli, Mumbai | ₹55–60 |
| Medium risk (urban core) | Koramangala, Bengaluru | ₹35–45 |
| Low risk (inland suburbs) | Whitefield, Bengaluru | ₹25–30 |

Worker pays via UPI. Policy activates within 24 hours.

### Step 4 — Real-Time Event Monitoring
Event Monitor polls external APIs every 5 minutes:

| Trigger | Data Source | Threshold |
|---------|------------|-----------|
| Rainfall | OpenWeather API | > 50mm/hr |
| Extreme heat | OpenWeather API | > 45°C |
| Pollution | AQICN API | AQI > 400 |
| Curfew / Section 144 | Government alert scraper | Any active order |
| Flooding | IMD / FloodWatch API | Red alert issued |

### Step 5 — Anti-Fraud Verification
Every triggered claim passes through our Trust Score Model before any payout is processed. Full detail in Section 7.

### Step 6 — Automated Claim & Payout
- Approved claims: payout sent within 10 minutes via Razorpay
- Payout = worker's average daily earnings × disruption duration in days
- Maximum payout: ₹1,500 per event (moral hazard cap)

---

## 5. Weekly Premium Model

### Why weekly and not monthly?

Gig workers think and earn in weekly cycles. A monthly premium of ₹200 feels large and abstract. A weekly premium of ₹40 feels like skipping two cups of chai. Weekly pricing also allows dynamic re-pricing — an incoming monsoon forecast increases next week's premium, giving workers advance notice.

### Premium Formula

```
Weekly Premium = Base Rate + Risk Adjustments

Base Rate = ₹25 (minimum floor)

Risk Adjustments:
  + Zone Flood Risk Score       → 0 to 15 points (IMD 3-year historical data)
  + Pollution Frequency         → 0 to 10 points (AQICN monthly averages)
  + Local Disruption History    → 0 to 10 points (claim rate in zone, last 90 days)

Maximum Premium = ₹65/week
```

### Payout Formula

```
Payout = Min(Daily Average Earnings × Disruption Days, ₹1,500)

Daily Average Earnings = Worker's weekly income ÷ 6 working days
Disruption Days = Hours of confirmed disruption ÷ 8
```

### Loss Ratio Target
We model a **60% loss ratio** — ₹60 in claims paid per ₹100 premium collected. The remaining 40% covers operations, API costs, and reserve fund.

---

## 6. AI & ML Strategy

### Model 1 — Risk Scoring Engine (Premium Calculation)

**Algorithm:** Random Forest Regressor

**Why Random Forest:** Works well with tabular, mixed-type data. Handles non-linear interactions naturally — high rainfall combined with high population density produces disproportionately higher disruption than either factor alone. Also interpretable — we can show workers exactly why their premium is set at a specific amount.

**Training Features:**
- Pin-code level rainfall history (3 years, IMD dataset)
- Monthly AQI averages by zone (AQICN historical data)
- City-level curfew event frequency (public records)
- Past claim frequency per pin code
- Delivery order volume drop percentage during past disruptions

**Output:** Risk Score (0–100) per delivery zone per week

---

### Model 2 — Fraud Detection

**Algorithms:** Isolation Forest + DBSCAN Clustering

**Isolation Forest** detects individual claim anomalies:
- Unusual GPS jump patterns
- Device behavior inconsistencies
- Claim timing anomalies relative to event timestamp

**DBSCAN Clustering** detects coordinated fraud rings:
- Groups claims that are suspiciously tight in time, location, and device type
- Flags clusters as potential syndicate activity for manual review

**Training Features:**
- GPS movement speed and route continuity score
- Device ID and mock location detection status
- Claim timing delta relative to event trigger
- IP address vs GPS location geographic distance
- Cell tower ping vs GPS location delta
- Number of simultaneous claims from same IP range or device type

**Output:** Anomaly score per claim, feeds directly into Trust Score

---

### Model 3 — Demand Forecasting (Phase 3)

**Algorithm:** LSTM Time-Series Model

**Purpose:** Predict high-risk weeks 5–7 days in advance to pre-build liquidity reserves before monsoon weeks and alert workers to purchase coverage before predicted events occur.

---

## 7. Adversarial Defense & Anti-Spoofing Strategy

> ⚠️ **Market Crash Response:** A coordinated syndicate of 500+ delivery workers organized via Telegram has been exploiting GPS-spoofing apps to fake their location inside red-alert weather zones, triggering mass false payouts and draining insurance liquidity pools. Simple GPS verification is officially obsolete. This section describes GigShield's complete defense architecture against this exact threat.

---

### Core Principle

> **We do not trust where a user says they are. We trust whether they behave like someone who is actually there.**

A real delivery worker caught in rain leaves a consistent, natural digital trail — they were moving, actively delivering, in the right area, on their real device, connected to a real local network. A fraudster sitting at home cannot simultaneously fake all of these signals.

---

### The Multi-Signal Trust Score Model

Every claim generates a **Trust Score from 0 to 100** across five independent signal categories:

```
Trust Score =
  Location Consistency Score     (0–25 points)
+ Behavioral Continuity Score    (0–20 points)
+ Device Authenticity Score      (0–20 points)
+ Environmental Match Score      (0–20 points)
+ Network Integrity Score        (0–15 points)
─────────────────────────────────────────────
Maximum Score                    = 100 points
```

**Decision Logic:**

| Score | Decision | Worker Experience |
|-------|----------|------------------|
| 75–100 | ✅ Auto-approved | Payout in under 10 min, zero friction |
| 40–74 | ⚠️ Soft verification | One simple check, takes under 30 seconds |
| 0–39 | ❌ Flagged for review | Claim held, worker notified transparently |

---

### Signal 1 — Location Consistency (0–25 points)

We check GPS movement history over the **2 hours before the claim**, not just the coordinate at claim time.

**What we analyze:**
- Is the device moving at delivery-worker speed (15–40 km/h on a bike)?
- Does the GPS trace follow real roads, or does it jump between coordinates?
- Did the device teleport — appearing in a new zone in under 60 seconds?
- Is this zone consistent with the worker's last 30 days of delivery activity?

**Red flags that reduce score:**
- Stationary device inside claimed disruption zone
- GPS coordinate jumps of 5+ km in under 60 seconds
- Worker has never delivered in the claimed zone before

---

### Signal 2 — Behavioral Continuity (0–20 points)

A genuine delivery worker caught in rain was actively working before the rain started.

**What we analyze:**
- Was the Zomato/Swiggy partner app active in the 30 minutes before the event?
- Did they accept or reject orders recently?
- Is the claim time consistent with their usual working hours?
- Was there an active delivery session that was interrupted by the event?

**The key insight:** A fraudster's device has no delivery trail. It simply appears in the disruption zone at claim time with no prior activity.

---

### Signal 3 — Device Authenticity (0–20 points)

**What we analyze:**
- Device ID matches the one registered during onboarding
- Android **"Allow mock locations"** developer setting — if enabled, score drops 20 points immediately, as GPS spoofing apps require this setting to function
- Emulator detection — claims from emulated Android devices are auto-rejected
- App tampering detection via SDK integrity check
- Single device filing claims across multiple worker accounts — primary syndicate signal

---

### Signal 4 — Environmental Match (0–20 points)

**What we analyze:**
- Does the weather API confirm the disruption at the worker's exact pin code — not the city average?
- Are other independently verified workers in the same pin code also experiencing the disruption?

**Syndicate detection via DBSCAN:**
If 50 workers submit claims from the same pin code within 15 minutes, but only 3 other independently verified workers in that zone are confirmed experiencing the event — that cluster is flagged as coordinated fraud. DBSCAN groups claims by time proximity, location proximity, and device type similarity. Any cluster that is anomalously tight across all three dimensions is held for review.

---

### Signal 5 — Network Integrity (0–15 points)

**What we analyze:**
- IP address geographic location vs GPS location — Mumbai GPS combined with Delhi IP is a major red flag
- Cell tower triangulation — mobile networks provide a coarse location estimate fully independent of GPS; we cross-reference both independently
- VPN detection — VPN usage is detectable and reduces the score as it obscures real network location

---

### UX Balance — Protecting Honest Workers

**Tier 1 — High Trust (Score 75–100):**
Fully automatic. No friction. Payout in under 10 minutes. The worker never knows a verification happened.

**Tier 2 — Medium Trust (Score 40–74):**
Soft verification. One of the following is requested:
- Confirm last delivery order ID — pulls from partner history, takes 10 seconds
- Quick selfie liveness check — proves the real person holds the device
- Passive re-verification — system re-checks GPS behavior naturally over 20 minutes, no action needed

Workers are never told their claim is suspicious. The message shown is: *"We are confirming your details to process your payout faster."*

**Tier 3 — Low Trust (Score below 40):**
Claim held. Worker receives: *"Your claim is under review. We will update you within 2 hours."* Human reviewer alerted. Genuine claims (e.g. real network failure) are paid with an apology notification.

**Grace rule for extreme weather:**
During confirmed red-alert events, GPS and mobile signal degrade naturally. A **+10 point grace adjustment** is applied to all claims submitted during active red-alert windows, ensuring genuine workers are never penalized by the very conditions that triggered their claim.

---

## 8. Tech Stack

| Layer | Technology | Reason |
|-------|-----------|--------|
| Frontend | React + Tailwind CSS | Fast UI, component-based |
| Backend | Python FastAPI | Lightweight, ML-native |
| Database | PostgreSQL | Reliable structured data |
| AI / ML | Scikit-learn | Random Forest, Isolation Forest, DBSCAN |
| Task Queue | Celery + Redis | Background API polling every 5 min |
| Weather | OpenWeather API | Pin-code level data, reliable uptime |
| Pollution | AQICN API | Free tier, global AQI coverage |
| Payments | Razorpay test mode | Indian market, UPI native |
| Deployment | Docker + AWS EC2 | Scalable from Phase 2 onward |

---

## 9. System Architecture

```
┌──────────────────────────────────────────────────────────┐
│                  External Data Sources                    │
│   OpenWeather  │  AQICN  │  Google Maps  │  Alert APIs   │
└─────────────────────────┬────────────────────────────────┘
                          │ polls every 5 minutes
                          ▼
                ┌──────────────────┐
                │  Event Monitor   │
                │  Celery + Redis  │
                └────────┬─────────┘
                         │ disruption detected
                         ▼
          ┌──────────────────────────────┐
          │     Anti-Spoofing Engine     │
          │    Trust Score Model 0–100   │
          │  Location · Behavior         │
          │  Device · Network · Env      │
          └────────┬──────────┬──────────┘
                   │ ≥75      │ <40
                   ▼          ▼
          ┌─────────────┐  ┌───────────────┐
          │Auto Approved│  │Flagged/Review │
          └──────┬──────┘  └───────────────┘
                 │
                 ▼
        ┌─────────────────┐
        │   Claim Engine  │
        └────────┬────────┘
                 │
                 ▼
        ┌─────────────────┐
        │ Razorpay Payout │
        │  under 10 min   │
        └────────┬────────┘
                 │
       ┌─────────┴──────────┐
       ▼                    ▼
┌─────────────┐     ┌───────────────┐
│   Worker    │     │     Admin     │
│  Dashboard  │     │   Dashboard   │
└─────────────┘     └───────────────┘
```

---

## 10. Roadmap

### Phase 1 — Ideation (Weeks 1–2) ← Current
- [x] Problem definition and persona selection
- [x] System architecture design
- [x] Weekly premium model
- [x] AI/ML strategy defined
- [x] Anti-spoofing defense architecture
- [x] Tech stack selection

### Phase 2 — Build (Weeks 3–4)
- [ ] Worker registration and onboarding flow
- [ ] AI risk profiling engine (live)
- [ ] Policy creation and management system
- [ ] Live event monitoring with 5 disruption triggers
- [ ] Automated claims pipeline
- [ ] Worker and admin dashboards
- [ ] 2-minute working demo video

### Phase 3 — Scale (Weeks 5–6)
- [ ] Full Trust Score Model implementation
- [ ] DBSCAN fraud ring detection at scale
- [ ] Instant payout simulation
- [ ] LSTM demand forecasting model
- [ ] Advanced analytics dashboard
- [ ] Final pitch deck and 5-minute demo video

---

## 11. Business Model

**Revenue:** Weekly premiums from delivery workers (₹30–65/week)

**Cost structure:**
- Claims payout: 60% of premium (loss ratio target)
- Operations and API costs: 15%
- Reserve fund: 15%
- Gross margin: 10%

**Market size:**
5 million food delivery workers × ₹40 average weekly premium = **₹200M per week addressable market in India alone.**

**Why the unit economics work:**
Parametric insurance has 10× lower operational costs than traditional insurance — no claim assessors, no paperwork, no manual fraud investigators needed at scale. Our automation makes thin per-policy margins viable at volume.

**Expansion path:**
- Phase 2: E-commerce delivery (Amazon / Flipkart)
- Phase 3: Grocery delivery (Zepto / Blinkit)
- Future: Direct premium deduction from weekly platform payouts

---

## 12. Demo Video

[Add your YouTube unlisted link here before submitting]

---

## Team

**Team Name:** [Mountain@Dew$!]

**Members:** [Sompalli Pothish, Anish Balaji A, RamMohan M,K Tejas Reddy, Parv Manyam]

Built for **DEVTrails 2026 Hackathon** — Guidewire

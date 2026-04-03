# GigShield Prototype

GigShield is a parametric income insurance platform tailored for Gig Workers in India (Zomato/Swiggy partners). It offers micro-insurance to protect workers against income disruption caused by heavy rain, severe AQI, heatwaves, or unexpected local curfews.

## 5. Weekly Premium Model
GigShield offers an extremely accessible flat weekly premium: ₹40/week.

### 5.1 Actuarial Basis
| Metric | Value | Reference |
| --- | --- | --- |
| Expected Claims/Year | 6.3 claims per worker | Based on IMD and AQICN historicals |
| Average Payout | ₹900 | 1.5 days avg disruption at ₹600/day |
| Loss Ratio Validation | ~59.6% | Target 60% loss ratio on ₹2080 annual premium |

## 8. Tech Stack
| Component | Technology | Reason |
| --- | --- | --- |
| Frontend | Flutter | Mobile-first, single codebase for Android/iOS, native UPI deep-link support, ideal for gig worker demographic (Android budget devices). |
| Backend | FastAPI (Python) | High-performance, fast asynchronous processing, robust ML capability integration |
| Database | SQLite/PostgreSQL | SQLite for demo, scalable to PostgreSQL for production |
| Machine Learning | Scikit-learn | Fast evaluation for Risk Scoring and Fraud Detection |

### 8.1 Standard Exclusions
*For the complete list with details and Hard/Soft classification, please refer to [insurance_exclusions.md](insurance_exclusions.md).*
- War, civil war, and armed conflict
- Pandemics, epidemics, and government-declared health emergencies
- Terrorism and acts of political violence
- Pre-existing medical conditions affecting ability to work
- Self-inflicted disruptions (worker intentionally not working)
- Mechanical breakdown of the worker's vehicle
- Acts of God beyond defined triggers (e.g. earthquake, lightning)
- Fraud or misrepresentation during onboarding
- Claims filed outside the 2-hour post-event window

## 12. Demo
View our hackathon project demo video:
*(YouTube Link to be placed here once uploaded)*

# GigShield DEVTrails 2026 Hackathon Submission Checklist

## 1. Documentation
- [ ] README.md updated with Flutter, exclusions section, actuarial basis
- [ ] insurance_exclusions.md complete with all 9 standard exclusions
- [ ] actuarial_analysis.md complete with loss ratio validation and stress test

## 2. Technical Build
- [ ] Flutter app: 4 screens working, routing complete, runs on Android emulator
- [ ] FastAPI backend: all 5 endpoints functional, Swagger docs at /docs
- [ ] ML stubs: both models trained, demo_ml.py prints results without errors
- [ ] All services integrated (risk → fraud → payout flow works end to end)

## 3. Hackathon Reviewer Gaps Addressed
- [ ] Standard exclusions defined (war, pandemic, terrorism, pre-existing conditions)
- [ ] Actuarial thinking quantified (claim frequency, loss ratio, reserve sizing, stress test)
- [ ] Flutter justified in README with gig worker demographic reasoning

## 4. Demo Video
- [ ] Under 2 minutes
- [ ] Shows: registration → rain trigger → fraud check → payout
- [ ] Uploaded to YouTube (unlisted) and link added to README Section 12

## 5. Final Checks
- [ ] Team name and members listed in README
- [ ] No hardcoded API keys in any file
- [ ] App runs without crash on fresh install
- [ ] /health endpoint returns 200

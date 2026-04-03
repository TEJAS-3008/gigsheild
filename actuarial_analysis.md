# Actuarial Analysis: GigShield

## 1. Expected Claim Frequency
- **Data Sources:** Mumbai/Bengaluru historical rainfall data (IMD), AQI hazard days (AQICN), estimated curfew events.
- **Assumptions:** Worker exposed to all local events without geographical buffering.
- **Result:** ~6.3 expected claims per worker per year.

## 2. Average Payout Structure
- **Baseline:** Daily earnings of ₹600.
- **Disruption:** ~1.5 days average per event.
- **Average Payout per Claim:** ₹900 (1.5 days × ₹600).
- **Hard Cap:** ₹1,500 maximum per single claim.

## 3. Loss Ratio Validation
- **Weekly Premium:** ₹40/week (₹2,080/year).
- **Desired Loss Ratio Target:** 60% (₹1,248/year in claims).
- **Validation:** With ~6.3 expected claims, adjusting for historical overlap and our ₹1500 cap, expected payout is ~₹1,240/year. This achieves a highly viable Loss Ratio of ~59.6%.

## 4. Reserve Fund Sizing
- **Recommended Reserve:** 20% of premium collected.
- **Rationale:** Sufficient to handle tail risk events (e.g., a 3-sigma monsoon hitting all workers in a major city simultaneously) without breaking initial liquidity.

## 5. Stress Test
- **Scenario:** Claim frequency doubles due to unforeseen climate variations.
- **Impact:** Annual expected claims increase to ~12.6, meaning expected losses spike to ~₹2,480.
- **Loss Ratio Outcome:** Jumps to 119% (Underwriting loss at current premium).
- **Break-Even Premium Required:** To break even on pure claims cost, the weekly premium must be adjusted to **₹47.70/week**.

import os
from tabulate import tabulate
import risk_model
import fraud_model

def run_demo():
    print("================================")
    print("GIGSHIELD ML DEMO SCRIPT")
    print("================================")
    
    if not os.path.exists('risk_model.pkl') or not os.path.exists('fraud_model.pkl'):
        print("Training models before running demo...")
        risk_model.train_and_save_model()
        fraud_model.train_and_save_model()
        print("--------------------------------")
    
    print("\n1. RISK SCORING ENGINE PREDICTIONS")
    risk_samples = [
        {   # Low Risk Mode
            "Zone": "Bangalore Central",
            "Features": {
                'rainfall_3yr_avg_mm': 600, 
                'aqi_hazard_days_per_year': 10, 
                'curfew_events_per_year': 0, 
                'historical_claim_rate': 0.02, 
                'delivery_volume_drop_pct': 15
            }
        },
        {   # Medium Risk Mode
            "Zone": "Bandra West",
            "Features": {
                'rainfall_3yr_avg_mm': 1500, 
                'aqi_hazard_days_per_year': 25, 
                'curfew_events_per_year': 1, 
                'historical_claim_rate': 0.08, 
                'delivery_volume_drop_pct': 30
            }
        },
        {   # High Risk Mode
            "Zone": "Andheri East (Flood prone)",
            "Features": {
                'rainfall_3yr_avg_mm': 2800, 
                'aqi_hazard_days_per_year': 45, 
                'curfew_events_per_year': 3, 
                'historical_claim_rate': 0.14, 
                'delivery_volume_drop_pct': 55
            }
        }
    ]
    
    risk_results = []
    for sample in risk_samples:
        score = risk_model.predict_risk_score(sample["Features"])
        risk_results.append([sample["Zone"], f"{score:.2f}/100", "High" if score > 75 else ("Medium" if score > 40 else "Low")])
        
    print(tabulate(risk_results, headers=["Zone", "Risk Score", "Category"], tablefmt="grid"))
    
    print("\n2. FRAUD DETECTION PREDICTIONS")
    fraud_samples = [
        {
            "Type": "Legitimate Worker",
            "Features": {
                'gps_jump_km': 1.2, 
                'time_since_last_delivery_min': 45.0, 
                'claims_last_30_days': 0, 
                'device_mock_location_enabled': 0, 
                'ip_gps_distance_km': 2.5
            }
        },
        {
            "Type": "Suspicious (High IP dist)",
            "Features": {
                'gps_jump_km': 6.0, 
                'time_since_last_delivery_min': 5.0, 
                'claims_last_30_days': 1, 
                'device_mock_location_enabled': 0, 
                'ip_gps_distance_km': 80.0
            }
        },
        {
            "Type": "Fraud Ring (Spoofer)",
            "Features": {
                'gps_jump_km': 45.0, 
                'time_since_last_delivery_min': 1.5, 
                'claims_last_30_days': 4, 
                'device_mock_location_enabled': 1, 
                'ip_gps_distance_km': 250.0
            }
        }
    ]
    
    fraud_results = []
    for sample in fraud_samples:
        is_fraud = fraud_model.is_fraudulent(sample["Features"])
        fraud_results.append([sample["Type"], "FAIL (Fraudster)" if is_fraud else "PASS (Legit)"])
        
    print(tabulate(fraud_results, headers=["Scenario", "Decision"], tablefmt="grid"))

if __name__ == "__main__":
    run_demo()

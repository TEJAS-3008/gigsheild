import numpy as np
import pandas as pd
from sklearn.ensemble import IsolationForest
import joblib

def generate_fraud_data(num_samples=500):
    np.random.seed(42)
    # 95% legit, 5% anomalous
    num_legit = int(num_samples * 0.95)
    num_fraud = num_samples - num_legit
    
    # Legit data distributions
    legit_gps_jump_km = np.random.uniform(0.1, 5, num_legit)
    legit_time_since_min = np.random.uniform(10, 120, num_legit)
    legit_claims_last_30 = np.random.randint(0, 2, num_legit)
    legit_mock_loc = np.zeros(num_legit)
    legit_ip_dist_km = np.random.uniform(0, 10, num_legit)
    
    # Fraud data distributions (anomalous)
    fraud_gps_jump_km = np.random.uniform(20, 100, num_fraud)
    fraud_time_since_min = np.random.uniform(0, 5, num_fraud)
    fraud_claims_last_30 = np.random.randint(3, 10, num_fraud)
    fraud_mock_loc = np.ones(num_fraud)
    fraud_ip_dist_km = np.random.uniform(50, 500, num_fraud)
    
    # Combine
    gps_jump_km = np.concatenate([legit_gps_jump_km, fraud_gps_jump_km])
    time_since_last_delivery_min = np.concatenate([legit_time_since_min, fraud_time_since_min])
    claims_last_30_days = np.concatenate([legit_claims_last_30, fraud_claims_last_30])
    device_mock_location_enabled = np.concatenate([legit_mock_loc, fraud_mock_loc])
    ip_gps_distance_km = np.concatenate([legit_ip_dist_km, fraud_ip_dist_km])
    
    X = pd.DataFrame({
        'gps_jump_km': gps_jump_km,
        'time_since_last_delivery_min': time_since_last_delivery_min,
        'claims_last_30_days': claims_last_30_days,
        'device_mock_location_enabled': device_mock_location_enabled,
        'ip_gps_distance_km': ip_gps_distance_km
    })
    
    # Shuffle
    X = X.sample(frac=1, random_state=42).reset_index(drop=True)
    return X

def train_and_save_model():
    print("Generating fraud training data (95% legit, 5% anomalies)...")
    X = generate_fraud_data(500)
    
    print("Training IsolationForest model...")
    # contamination=0.05 matches our 5% injected anomalies
    model = IsolationForest(n_estimators=100, contamination=0.05, random_state=42)
    model.fit(X)
    
    joblib.dump(model, 'fraud_model.pkl')
    print("Model saved to fraud_model.pkl")

def is_fraudulent(claim_features: dict) -> bool:
    """
    Returns True if the claim appears fraudulent, False if legitimate.
    """
    try:
        model = joblib.load('fraud_model.pkl')
    except Exception:
        return False
        
    df = pd.DataFrame([claim_features])
    
    cols = ['gps_jump_km', 'time_since_last_delivery_min', 'claims_last_30_days', 
            'device_mock_location_enabled', 'ip_gps_distance_km']
    df = df[cols]
    
    # Isolation forest returns 1 for inliers (normal) and -1 for outliers (fraud)
    prediction = model.predict(df)[0]
    return prediction == -1

if __name__ == "__main__":
    train_and_save_model()

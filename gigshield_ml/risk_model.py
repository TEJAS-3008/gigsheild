import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
import joblib

def generate_training_data(num_samples=200):
    np.random.seed(42)
    # realistic ranges for Mumbai/Bengaluru zones
    rainfall_3yr_avg_mm = np.random.uniform(500, 3000, num_samples)
    aqi_hazard_days_per_year = np.random.uniform(5, 50, num_samples)
    curfew_events_per_year = np.random.randint(0, 5, num_samples)
    historical_claim_rate = np.random.uniform(0.01, 0.15, num_samples)
    delivery_volume_drop_pct = np.random.uniform(10, 60, num_samples)
    
    # Calculate a composite 'true' risk score (0-100) based on features + noise
    base_score = (
        (rainfall_3yr_avg_mm / 3000) * 30 + 
        (aqi_hazard_days_per_year / 50) * 20 + 
        (curfew_events_per_year / 4) * 20 + 
        (historical_claim_rate / 0.15) * 15 + 
        (delivery_volume_drop_pct / 60) * 15
    )
    noise = np.random.normal(0, 5, num_samples)
    target_risk_score = np.clip(base_score + noise, 0, 100)
    
    X = pd.DataFrame({
        'rainfall_3yr_avg_mm': rainfall_3yr_avg_mm,
        'aqi_hazard_days_per_year': aqi_hazard_days_per_year,
        'curfew_events_per_year': curfew_events_per_year,
        'historical_claim_rate': historical_claim_rate,
        'delivery_volume_drop_pct': delivery_volume_drop_pct
    })
    y = target_risk_score
    return X, y

def train_and_save_model():
    print("Generating risk training data...")
    X, y = generate_training_data(200)
    
    print("Training RandomForestRegressor Risk model...")
    model = RandomForestRegressor(n_estimators=100, random_state=42)
    model.fit(X, y)
    
    print("Feature Importances:")
    importances = list(zip(X.columns, model.feature_importances_))
    importances.sort(key=lambda x: x[1], reverse=True)
    for feat, imp in importances:
        print(f" - {feat}: {imp:.4f}")
        
    joblib.dump(model, 'risk_model.pkl')
    print("Model saved to risk_model.pkl")

# Used for inference
def predict_risk_score(pin_code_features: dict) -> float:
    """
    Predict risk score given a dictionary of features.
    """
    try:
        model = joblib.load('risk_model.pkl')
    except Exception:
        # Fallback if not trained
        return 50.0 
        
    df = pd.DataFrame([pin_code_features])
    
    # Ensure correct column order
    cols = ['rainfall_3yr_avg_mm', 'aqi_hazard_days_per_year', 'curfew_events_per_year', 
            'historical_claim_rate', 'delivery_volume_drop_pct']
    df = df[cols]
    
    prediction = model.predict(df)[0]
    return float(np.clip(prediction, 0, 100))

if __name__ == "__main__":
    train_and_save_model()

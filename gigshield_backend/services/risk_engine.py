import random

# Mock Risk Map for Mumbai/Bengaluru Pin Codes
RISK_MAP = {
    "400053": 85,  # Andheri East (High risk, flood prone)
    "400050": 60,  # Bandra West (Medium risk)
    "560037": 90,  # Marathahalli (High risk, traffic/flood)
    "560001": 40,  # MG Road (Low risk)
    "400001": 45,  # Fort, Mumbai (Low risk)
}

def predict_risk_score(pin_code: str) -> float:
    """Returns a risk score 0-100 based on pin code history"""
    return RISK_MAP.get(pin_code, random.uniform(40, 80))

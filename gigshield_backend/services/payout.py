import uuid
import time

def process_payout(claim_id: str, amount: float) -> dict:
    """Mock Razorpay call simulation"""
    # Simulate API latency
    time.sleep(0.5)
    return {
        "utr": f"RZP_MOCK_{uuid.uuid4().hex[:8].upper()}",
        "status": "success",
        "amount": amount
    }

def evaluate_fraud(trust_score: int) -> str:
    """Evaluate trust score into actionable claim statuses"""
    if trust_score > 75:
        return "approved"
    elif 40 <= trust_score <= 74:
        return "soft_verify"
    else:
        return "flagged"

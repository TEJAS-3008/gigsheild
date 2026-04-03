from fastapi import APIRouter
import uuid
from datetime import datetime

from models.claim import TriggerEvent, Claim
from models.worker import WorkerProfile
from db.database import get_workers_by_pincode, add_claim
from services.fraud_check import evaluate_fraud

router = APIRouter(prefix="/events", tags=["Events"])

# MOCK thresholds
THRESHOLDS = {
    "rain": 50.0, # mm
    "aqi": 400.0,
}

@router.post("/trigger")
def trigger_event(event: TriggerEvent):
    threshold = THRESHOLDS.get(event.event_type.lower())
    
    if threshold and event.value <= threshold:
        return {"msg": f"{event.event_type} value {event.value} did not cross threshold {threshold}"}
    
    workers = get_workers_by_pincode(event.pin_code)
    claims_created = []
    
    for w in workers:
        status = evaluate_fraud(w["trust_score"])
        
        claim_id = f"c_{uuid.uuid4().hex[:8]}"
        claim = Claim(
            claim_id=claim_id,
            worker_id=w["worker_id"],
            event_type=event.event_type,
            status=status,
            amount=900.0,  # 1.5 days * 600
            timestamp=datetime.now()
        )
        add_claim(claim.dict())
        claims_created.append(claim.dict())
        
    return {
        "msg": "Event processed",
        "affected_workers_count": len(workers),
        "claims_created": claims_created
    }

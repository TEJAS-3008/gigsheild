from fastapi import APIRouter, HTTPException
import uuid
import random

from models.worker import WorkerRegistration, WorkerProfile
from db.database import add_worker, get_worker

router = APIRouter(prefix="/workers", tags=["Workers"])

@router.post("/register")
def register_worker(worker: WorkerRegistration):
    worker_id = f"w_{uuid.uuid4().hex[:8]}"
    trust_score = random.randint(75, 95)
    
    profile = WorkerProfile(
        worker_id=worker_id,
        name=worker.name,
        phone=worker.phone,
        pin_code=worker.pin_code,
        platform=worker.platform,
        weekly_earnings=worker.weekly_earnings,
        trust_score=trust_score,
        policy_details={
            "status": "PROTECTED",
            "premium": 40.0,
            "coverage_triggers": ["Rain >50mm", "AQI >400", "Curfew", "Flood", "Extreme Heat"],
            "next_renewal_date": "2026-04-10"
        }
    )
    add_worker(profile.dict())
    
    return {
        "worker_id": profile.worker_id,
        "trust_score": profile.trust_score,
        "policy_details": profile.policy_details
    }

@router.get("/{worker_id}/policy")
def get_policy(worker_id: str):
    worker = get_worker(worker_id)
    if not worker:
        raise HTTPException(status_code=404, detail="Worker not found")
    return {
        "active_policy": True,
        "premium": worker["policy_details"]["premium"],
        "coverage_triggers": worker["policy_details"]["coverage_triggers"],
        "next_renewal_date": worker["policy_details"]["next_renewal_date"]
    }

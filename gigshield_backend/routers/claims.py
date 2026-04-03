from fastapi import APIRouter, HTTPException
from db.database import get_claims_by_worker, get_claim, add_claim
from services.payout import process_payout

router = APIRouter(prefix="/claims", tags=["Claims"])

@router.get("/{worker_id}")
def get_worker_claims(worker_id: str):
    claims = get_claims_by_worker(worker_id)
    return {"claims": claims}

@router.post("/{claim_id}/payout")
def payout_claim(claim_id: str):
    claim = get_claim(claim_id)
    if not claim:
        raise HTTPException(status_code=404, detail="Claim not found")
        
    if claim["status"] != "approved":
        raise HTTPException(status_code=400, detail="Claim needs to be approved before payout")
        
    if claim["utr"] is not None:
        raise HTTPException(status_code=400, detail="Payout already processed")

    payout_result = process_payout(claim_id, claim["amount"])
    
    # Update claim with utr
    claim["utr"] = payout_result["utr"]
    claim["status"] = "paid"
    add_claim(claim) # Update in "db"
    
    return payout_result

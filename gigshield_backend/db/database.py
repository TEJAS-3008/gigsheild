# Simple mockup database for demo purposes (can be swapped with SQLAlchemy engine later)

workers_db = {}
claims_db = {}

def get_worker(worker_id: str):
    return workers_db.get(worker_id)

def add_worker(worker: dict):
    workers_db[worker["worker_id"]] = worker
    return worker

def get_claim(claim_id: str):
    return claims_db.get(claim_id)

def add_claim(claim: dict):
    claims_db[claim["claim_id"]] = claim
    return claim

def get_claims_by_worker(worker_id: str):
    return [c for c in claims_db.values() if c["worker_id"] == worker_id]

def get_workers_by_pincode(pin_code: str):
    return [w for w in workers_db.values() if w["pin_code"] == pin_code]

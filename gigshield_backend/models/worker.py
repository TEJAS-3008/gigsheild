from pydantic import BaseModel
from typing import Optional

class WorkerRegistration(BaseModel):
    name: str
    phone: str
    pin_code: str
    platform: str
    weekly_earnings: float

class WorkerProfile(BaseModel):
    worker_id: str
    name: str
    phone: str
    pin_code: str
    platform: str
    weekly_earnings: float
    trust_score: int
    policy_details: dict

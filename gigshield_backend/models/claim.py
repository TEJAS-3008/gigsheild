from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class TriggerEvent(BaseModel):
    event_type: str
    pin_code: str
    value: float

class Claim(BaseModel):
    claim_id: str
    worker_id: str
    event_type: str
    status: str
    amount: float
    timestamp: datetime
    utr: Optional[str] = None

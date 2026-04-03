from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from apscheduler.schedulers.background import BackgroundScheduler
from services.external_apis import run_poller_sync

from routers import workers, events, claims

app = FastAPI(
    title="GigShield API",
    description="Parametric Income Insurance Platform API",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(workers.router)
app.include_router(events.router)
app.include_router(claims.router)

@app.on_event("startup")
def start_scheduler():
    scheduler = BackgroundScheduler()
    # Run the poller every 15 minutes
    scheduler.add_job(run_poller_sync, 'interval', minutes=15)
    scheduler.start()

@app.get("/health", tags=["System"])
def health_check():
    return {"status": "healthy"}

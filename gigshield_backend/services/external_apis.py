import httpx
import os
import asyncio
from bs4 import BeautifulSoup
import logging

logger = logging.getLogger("api_poller")
logger.setLevel(logging.INFO)

# Run server on 8000
BACKEND_URL = "http://127.0.0.1:8000"

GEO_MAP = {
    "400053": {"lat": 19.1136, "lon": 72.8697, "city": "mumbai"},
    "560037": {"lat": 12.9591, "lon": 77.6974, "city": "bangalore"}
}

async def notify_backend(event_type: str, pin: str, value: float):
    payload = {
        "event_type": event_type,
        "pin_code": pin,
        "value": value
    }
    async with httpx.AsyncClient() as client:
        try:
            await client.post(f"{BACKEND_URL}/events/trigger", json=payload)
            logger.info(f"Triggered backend for {event_type} at {pin}")
        except Exception as e:
            logger.error(f"Failed to notify backend: {e}")

async def fetch_aqicn(lat: float, lon: float, pin: str):
    token = os.getenv("AQICN_TOKEN", "demo")
    url = f"https://api.waqi.info/feed/geo:{lat};{lon}/?token={token}"
    async with httpx.AsyncClient() as client:
        try:
            res = await client.get(url)
            data = res.json()
            if data.get("status") == "ok":
                aqi = data["data"]["aqi"]
                logger.info(f"AQICN Data for {pin}: {aqi}")
                if aqi > 400:
                    await notify_backend("aqi", pin, float(aqi))
        except Exception as e:
            logger.error(f"AQICN Error: {e}")

async def fetch_floodapi(lat: float, lon: float, pin: str):
    # Open-Meteo Flood API proxy
    url = f"https://flood-api.open-meteo.com/v1/flood?latitude={lat}&longitude={lon}&daily=river_discharge"
    async with httpx.AsyncClient() as client:
        try:
            res = await client.get(url)
            data = res.json()
            if "daily" in data and "river_discharge" in data["daily"]:
                discharge = data["daily"]["river_discharge"][0]
                logger.info(f"Flood River Discharge for {pin}: {discharge}")
                if discharge and discharge > 1000:
                    await notify_backend("flood", pin, float(discharge))
        except Exception as e:
            logger.error(f"Flood API Error: {e}")

async def fetch_imd_weather(lat: float, lon: float, pin: str):
    # Open-Meteo Current proxy for IMD data
    url = f"https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current=precipitation"
    async with httpx.AsyncClient() as client:
        try:
            res = await client.get(url)
            data = res.json()
            rain_mm = data.get("current", {}).get("precipitation", 0.0)
            logger.info(f"IMD Rainfall for {pin}: {rain_mm}mm")
            # The backend threshold is 50.0
            if rain_mm > 50.0:
                await notify_backend("rain", pin, float(rain_mm))
        except Exception as e:
            logger.error(f"IMD Weather Error: {e}")

async def scrape_gov_alerts(city: str, pin: str):
    url = "https://ndmindia.mha.gov.in/"
    async with httpx.AsyncClient() as client:
        try:
            # We mock the headers to prevent basic scrapper blocks
            headers = {"User-Agent": "Mozilla/5.0"}
            res = await client.get(url, headers=headers, timeout=10.0)
            soup = BeautifulSoup(res.text, 'html.parser')
            alerts = soup.find_all(lambda tag: tag.name == 'marquee' or (tag.name == 'div' and 'alert' in tag.get('class', [])))
            alert_text = " ".join([a.text.lower() for a in alerts])
            
            logger.info(f"Gov Alerts for {city} scraped successfully.")
            if "curfew" in alert_text or "lockdown" in alert_text:
                if city.lower() in alert_text:
                     await notify_backend("curfew", pin, 1.0)
        except Exception as e:
            logger.error(f"Gov Scraper Error: {e}")

async def poll_all_sources():
    logger.info("--- Polling all Environmental Sources ---")
    tasks = []
    for pin, geo in GEO_MAP.items():
        tasks.append(fetch_aqicn(geo["lat"], geo["lon"], pin))
        tasks.append(fetch_floodapi(geo["lat"], geo["lon"], pin))
        tasks.append(fetch_imd_weather(geo["lat"], geo["lon"], pin))
        tasks.append(scrape_gov_alerts(geo["city"], pin))
    
    await asyncio.gather(*tasks)

def run_poller_sync():
    asyncio.run(poll_all_sources())

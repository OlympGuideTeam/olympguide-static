import os
import requests
from bs4 import BeautifulSoup

URL = "https://ba.hse.ru/bolimp"
BASE_URL = "https://ba.hse.ru"

SAVE_DIR = "benefits"
os.makedirs(SAVE_DIR, exist_ok=True)

response = requests.get(URL)
response.raise_for_status()

soup = BeautifulSoup(response.text, "html.parser")

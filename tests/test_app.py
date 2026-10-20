
import sys
import os
# Tells Python to look in the parent directory for app.py
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from app import app

def test_hello():
    client = app.test_client()
    response = client.get('/')
    assert response.status_code == 200
    assert b"Hello from inside a Docker Container!" in response.data
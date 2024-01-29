from typing import Union
from fastapi import FastAPI
import os

app = FastAPI()

@app.get("/env")
def read_env():
    return {"No Secret" if not os.environ.get('MYSECRET') else os.environ['MYSECRET']}

@app.get("/version")
def red_version():
    # Read version from file
    with open("version.txt") as f:
        return f.read()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
from flask import Flask
import time

app = Flask(__name__)
start_time = time.time()

@app.route("/liveness")
def liveness():
    return "I'm alive!", 200

@app.route("/readiness")
def readiness():
    elapsed = time.time() - start_time
    if elapsed < 75:
        return "Readiness probe: Not ready yet", 500
    elif elapsed >= 240:
        return "Readiness probe: Became unhealthy again", 500
    return "Readiness probe: Ready", 200

@app.route("/startup")
def startup():
    elapsed = time.time() - start_time
    if elapsed < 60:
        return "Startup probe: Still starting", 500
    return "Startup probe: Started", 200

@app.route("/")
def home():
    return "Hello from Probe Tester App!", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)

from flask import Flask, Blueprint
import time

readiness_bp = Blueprint('readiness', __name__)
start_time = time.time()

@readiness_bp.route("/readiness")
def readiness():
    elapsed = time.time() - start_time
    if elapsed < 75:
        return "Readiness probe: Not ready yet", 500
    elif elapsed >= 240:
        return "Readiness probe: Became unhealthy again", 500
    return "Readiness probe: Ready", 200

def register_readiness(app: Flask):
    app.register_blueprint(readiness_bp)

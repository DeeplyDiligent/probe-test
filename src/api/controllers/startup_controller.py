from flask import Flask, Blueprint
import time

startup_bp = Blueprint('startup', __name__)
start_time = time.time()

@startup_bp.route("/startup")
def startup():
    elapsed = time.time() - start_time
    if elapsed < 60:
        return "Startup probe: Still starting", 500
    return "Startup probe: Started", 200

def register_startup(app: Flask):
    app.register_blueprint(startup_bp)

from flask import Flask, Blueprint

home_bp = Blueprint('home', __name__)

@home_bp.route("/")
def home():
    return "Hello from Probe Tester App!", 200

def register_home(app: Flask):
    app.register_blueprint(home_bp)

from flask import Flask, Blueprint

liveness_bp = Blueprint('liveness', __name__)

@liveness_bp.route("/liveness")
def liveness():
    return "I'm alive!", 200

def register_liveness(app: Flask):
    app.register_blueprint(liveness_bp)

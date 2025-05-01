import unittest
from flask import Flask
from src.api.controllers.liveness_controller import register_liveness
from src.api.controllers.readiness_controller import register_readiness
from src.api.controllers.startup_controller import register_startup
from src.api.controllers.home_controller import register_home

class TestControllers(unittest.TestCase):

    def setUp(self):
        self.app = Flask(__name__)
        register_liveness(self.app)
        register_readiness(self.app)
        register_startup(self.app)
        register_home(self.app)
        self.client = self.app.test_client()

    def test_liveness(self):
        response = self.client.get('/liveness')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data.decode(), "I'm alive!")

    def test_readiness(self):
        response = self.client.get('/readiness')
        self.assertEqual(response.status_code, 500)

    def test_startup(self):
        response = self.client.get('/startup')
        self.assertEqual(response.status_code, 500)

    def test_home(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data.decode(), "Hello from Probe Tester App!")

if __name__ == '__main__':
    unittest.main()

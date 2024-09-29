
from flask import Flask
from flask_cors import CORS  # Import CORS
from app.config import Config
from app.utils.db_connector import get_db_connection

# Initialize the Flask app
app = Flask(__name__)
app.config.from_object(Config)

# Enable CORS for all routes
CORS(app)  # This will allow cross-origin requests for your entire app

# Initialize database connection
db = get_db_connection()

# Import routes from main
from app import main



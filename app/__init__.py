
from flask import Flask
from app.config import Config
from app.utils.db_connector import get_db_connection

# Initialize the Flask app
app = Flask(__name__)
app.config.from_object(Config)

# Initialize database connection
db = get_db_connection()

from app import main  # Import routes from main

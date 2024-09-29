import sys
import logging

# Add your application directory to the PYTHONPATH
sys.path.insert(0, '/var/www/html/app/app')

from app import app as application
# Ensure you are importing the Flask

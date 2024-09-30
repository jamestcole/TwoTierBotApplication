import sys
import logging

# Add the virtual environment's site-packages to the sys.path
venv_site_packages = '/var/www/html/app/venv/lib/python3.12/site-packages'
sys.path.insert(0, venv_site_packages)

# Add your application directory to the PYTHONPATH
sys.path.insert(0, '/var/www/html/app')


from app import app as application
# Ensure you are importing the Flask

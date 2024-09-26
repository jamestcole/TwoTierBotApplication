import MySQLdb
from app.config import Config

def get_db_connection():
    connection = MySQLdb.connect(
        host=Config.DB_HOST,
        user=Config.DB_USER,
        password=Config.DB_PASSWORD,
        db=Config.DB_NAME
    )
    return connection

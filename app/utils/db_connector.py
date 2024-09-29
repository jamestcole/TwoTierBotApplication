import pymysql as MySQLdb
from app.config import Config

def get_db_connection():
    try:
        connection = MySQLdb.connect(
            host=Config.DB_HOST,
            user=Config.DB_USER,
            password=Config.DB_PASSWORD,
            db=Config.DB_NAME
        )
        return connection
    except MySQLdb.Error as e:
        print(f"Error connecting to MySQL Database: {e}")
        return None

import mysql.connector
import os
from dotenv import load_dotenv

load_dotenv()

MYSQL_HOST = os.environ["MYSQL_HOST"]
MYSQL_PORT = int(os.environ["MYSQL_PORT"])
MYSQL_USER = os.environ["MYSQL_USER"]
MYSQL_PASSWORD = os.environ["MYSQL_PASSWORD"]
MYSQL_DB_NAME = os.environ["MYSQL_DB_NAME"]

def create_auth_db_connection():
    return mysql.connector.connect(
        host=MYSQL_HOST,
        port=MYSQL_PORT,
        user=MYSQL_USER,
        password=MYSQL_PASSWORD,
        database=MYSQL_DB_NAME,
    )

def get_project_transactions_data():
    conn = create_auth_db_connection()
    cursor = conn.cursor(dictionary=True)

    query = """
        SELECT id, owner_merchant_id, amount, created_at 
        FROM core.project_transactions
        ORDER BY id DESC LIMIT 20
    """
    cursor.execute(query)
    transactions = cursor.fetchall()

    cursor.close()
    conn.close()

    return transactions
    

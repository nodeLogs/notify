import os
import mysql.connector
from dotenv import load_dotenv

load_dotenv()

# Замените значения переменных на ваши настройки для базы данных "auth"
MYSQL_HOST = os.environ["MYSQL_HOST"]
MYSQL_PORT = int(os.environ["MYSQL_PORT"])
MYSQL_USER = os.environ["MYSQL_USER"]
MYSQL_PASSWORD = os.environ["MYSQL_PASSWORD"]
MYSQL_DB_MERCHANT = os.environ["MYSQL_DB_MERCHANT"]

def create_auth_db_connection():
    return mysql.connector.connect(
        host=MYSQL_HOST,
        port=MYSQL_PORT,
        user=MYSQL_USER,
        password=MYSQL_PASSWORD,
        database=MYSQL_DB_MERCHANT,
    )

def get_merchants_data():
    conn = create_auth_db_connection()
    cursor = conn.cursor(dictionary=True)

    query = "SELECT merchant_id, id_merchant FROM merchant_data"
    cursor.execute(query)
    result = cursor.fetchall()

    merchant_data = {row['merchant_id']: row['id_merchant'] for row in result}

    cursor.close()
    conn.close()

    return merchant_data

# def print_merchants_data():
#     merchants_data = get_merchants_data()
#     print("Merchant Data:")
#     for merchant_id, merchant_name in merchants_data.items():
#         print(f"{merchant_id}: {merchant_name}")

# if __name__ == "__main__":
#     print_merchants_data()

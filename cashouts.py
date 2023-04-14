import os
import time
import mysql.connector
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError
from collections import deque
from dotenv import load_dotenv

load_dotenv()

# Замените значения переменных на ваши настройки
MYSQL_HOST = os.environ["MYSQL_HOST"]
MYSQL_PORT = int(os.environ["MYSQL_PORT"])  # Преобразовать значение порта в int
MYSQL_USER = os.environ["MYSQL_USER"]
MYSQL_PASSWORD = os.environ["MYSQL_PASSWORD"]
MYSQL_DB_NAME = os.environ["MYSQL_DB_NAME"]

SLACK_BOT_TOKEN = os.environ["SLACK_BOT_TOKEN"]
SLACK_CHANNEL_ID = os.environ["SLACK_CHANNEL_ID"]

# Создание подключения к базе данных
def create_db_connection():
    return mysql.connector.connect(
        host=MYSQL_HOST,
        port=MYSQL_PORT,
        user=MYSQL_USER,
        password=MYSQL_PASSWORD,
        database=MYSQL_DB_NAME,
    )

# Создание клиента Slack API
slack_client = WebClient(token=SLACK_BOT_TOKEN)

def get_status_text(status):
    if status == 'in_progress':
        return ':large_yellow_circle: Transaction in progress'
    elif status == 'success':
        return ':large_green_circle: Transaction success'
    elif status == 'rejected':
        return ':red_circle: Transaction decline'
    elif status == 'pending':
        return ':exclamation: Transaction awaiting provider approval @operations'
    else:
        return status

def send_slack_message(transaction):
    message_template = f"""*Merchant Cashout*

:date:  *Created*: {transaction['created_at']}
:link:  *Transaction ID*: {transaction['id']}
:man_in_tuxedo:  *Merchant*: <https://cryptoprocessing-stage.corp.merehead.xyz/merchant/{transaction['owner_merchant_id']}/projects|Joy Casino>
:slot_machine:  *Project*: <https://cryptoprocessing-stage.corp.merehead.xyz/merchant/{transaction['owner_merchant_id']}/project/{transaction['project_id']}/settings/details|Joy Casino Project>
:money_with_wings:  *Amount*:  {transaction['amount']} {transaction['currency_network']}

{get_status_text(transaction['status'])}
"""
    try:
        response = slack_client.chat_postMessage(
            channel=SLACK_CHANNEL_ID,
            text=message_template
        )
        return response['ts']
    except SlackApiError as e:
        print(f"Error sending message: {e}")

def update_slack_message(transaction, ts):
    message_template = f"""*Merchant Cashout*

:date:  *Created*: {transaction['created_at']}
:link:  *Transaction ID*: {transaction['id']}
:man_in_tuxedo:  *Merchant*: <https://cryptoprocessing-stage.corp.merehead.xyz/merchant/{transaction['owner_merchant_id']}/projects|Joy Casino>
:slot_machine:  *Project*: <https://cryptoprocessing-stage.corp.merehead.xyz/merchant/{transaction['owner_merchant_id']}/project/{transaction['project_id']}/settings/details|Joy Casino Project>
:money_with_wings:  *Amount*:  {transaction['amount']} {transaction['currency_network']}

{get_status_text(transaction['status'])}
"""
    try:
        slack_client.chat_update(
            channel=SLACK_CHANNEL_ID,
            ts=ts,
            text=message_template
        )
    except SlackApiError as e:
        print(f"Error updating message: {e}")

def get_current_last_id():
    conn = create_db_connection()
    cursor = conn.cursor(dictionary=True)

    query = "SELECT id FROM project_withdrawal_crypto_transactions ORDER BY id DESC LIMIT 1"
    cursor.execute(query)
    result = cursor.fetchone()

    cursor.close()
    conn.close()

    if result:
        return result['id']
    return None

def monitor_transactions():
    last_processed_id = get_current_last_id()
    message_ts_map = {}

    while True:
        conn = create_db_connection()
        cursor = conn.cursor(dictionary=True)

        query = "SELECT * FROM project_withdrawal_crypto_transactions"
        if last_processed_id:
            query += f" WHERE id > {last_processed_id}"
        query += " ORDER BY id DESC"

        cursor.execute(query)
        result = cursor.fetchall()

        for row in result:
            if row['id'] not in message_ts_map:
                ts = send_slack_message(row)
                message_ts_map[row['id']] = ts
                last_processed_id = row['id']
            else:
                ts = message_ts_map.get(row['id'])
                if ts:
                    update_slack_message(row, ts)

        # Добавим код для проверки статусов сообщений, отправленных после запуска бота
        for transaction_id, ts in message_ts_map.items():
            query = f"SELECT * FROM project_withdrawal_crypto_transactions WHERE id = {transaction_id}"
            cursor.execute(query)
            row = cursor.fetchone()

            if row:
                update_slack_message(row, ts)

        cursor.close()
        conn.close()

        time.sleep(5)

if __name__ == "__main__":
    monitor_transactions()

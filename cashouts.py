import os
import time

import mysql.connector
from dotenv import load_dotenv
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

from merchants_data import get_merchants_data
from project_transactions_data import get_project_transactions_data

load_dotenv()
previous_statuses = {}

MYSQL_HOST = os.environ["MYSQL_HOST"]
MYSQL_PORT = int(os.environ["MYSQL_PORT"])
MYSQL_USER = os.environ["MYSQL_USER"]
MYSQL_PASSWORD = os.environ["MYSQL_PASSWORD"]
MYSQL_DB_NAME = os.environ["MYSQL_DB_NAME"]

SLACK_BOT_TOKEN = os.environ["SLACK_BOT_TOKEN"]
SLACK_CHANNEL_ID = os.environ["SLACK_CHANNEL_ID"]

def create_db_connection():
    return mysql.connector.connect(
        host=MYSQL_HOST,
        port=MYSQL_PORT,
        user=MYSQL_USER,
        password=MYSQL_PASSWORD,
        database=MYSQL_DB_NAME,
    )

slack_client = WebClient(token=SLACK_BOT_TOKEN)

def get_status_text(status):
    if status == 'in_progress':
        return ':large_yellow_circle: Transaction in progress'
    elif status == 'success':
        return ':large_green_circle: Transaction success\n'
    elif status == 'rejected':
        return ':red_circle: Transaction decline'
    elif status == 'pending':
        return ':exclamation: Transaction awaiting provider approval @operations'
    else:
        return status

def send_slack_message(transaction, project_name, merchant_name, real_transaction_id):
    message_template = f""">*ManualCashout*
:man_in_tuxedo: <https://cryptoprocessing-stage.corp.merehead.xyz/merchant/{transaction['owner_merchant_id']}/projects|{merchant_name}> | <https://cryptoprocessing-stage.corp.merehead.xyz/merchant/{transaction['owner_merchant_id']}/projects/{transaction['project_id']}/settings/details|{project_name}>
:link: <https://cryptoprocessing-stage.corp.merehead.xyz/merchant/{transaction['owner_merchant_id']}/project/{transaction['project_id']}/transaction/details/{real_transaction_id}/crypto/withdrawal|Transaction #{real_transaction_id}>
:money_with_wings: -{transaction['amount']} {transaction['currency_network']}

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

def post_status_in_thread(transaction, ts):
    status_text = get_status_text(transaction['status'])

    # Добавить хэш транзакции в текст сообщения, если статус равен "success" + ссылка на блокчейн обозреватель.
    if transaction['status'] == 'success':
        if transaction['currency_network'] == 'trx':
          status_text += f"\nhttps://tronscan.org/#/transaction/{transaction['hash_transaction']}"
        elif transaction['currency_network'] == 'eth':
            status_text += f"\nhttps://etherscan.io/tx/{transaction['hash_transaction']}"

    try:
        slack_client.chat_postMessage(
            channel=SLACK_CHANNEL_ID,
            text=status_text,
            thread_ts=ts
        )
    except SlackApiError as e:
        print(f"Error posting status in thread: {e}")


def update_slack_message(transaction, ts):
    current_status = transaction["status"]
    previous_status = previous_statuses.get(transaction["id"])

    if previous_status is None:
        previous_statuses[transaction["id"]] = current_status
    elif current_status != previous_status:
        post_status_in_thread(transaction, ts)
        previous_statuses[transaction["id"]] = current_status

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
    merchants = get_merchants_data()
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
            project_transactions_data = get_project_transactions_data()
            merchant_name = merchants.get(row['owner_merchant_id'], 'Unknown')
            project_query = f"SELECT name FROM projects WHERE id = {row['project_id']}"
            cursor.execute(project_query)
            project = cursor.fetchone()
            project_name = project['name'] if project else 'Unknown'

            real_transaction_id = None
            for transaction in project_transactions_data:
                if (
                    transaction["amount"] == row["amount"]
                    and transaction["owner_merchant_id"] == row["owner_merchant_id"]
                    and transaction["created_at"] == row["created_at"]
                ):
                    real_transaction_id = transaction["id"]
                    break

            if real_transaction_id is None:
                print(f"Warning: Real transaction ID not found for withdrawal transaction ID {row['id']}")
            else:
                ts = send_slack_message(row, project_name, merchant_name, real_transaction_id)

                if row['id'] not in message_ts_map:
                    message_ts_map[row['id']] = ts
                    last_processed_id = row['id']
                else:
                    ts = message_ts_map.get(row['id'])
                    if ts:
                        update_slack_message(row, ts)

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


FROM python:3.8-slim
WORKDIR /root/notify
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD python exchange_transactions.py & python risk_score.py & python cashouts.py
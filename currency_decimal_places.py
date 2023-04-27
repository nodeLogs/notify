currency_decimal_places = {
    'TRX': 2,
    'ETH': 6,
    'BTC': 7,
    'DOGE': 2,
    'USDT': 2,
    'USDC': 2,
}

def format_amount(amount, currency):
    decimal_places = currency_decimal_places.get(currency.upper(), 2)  # Use 2 as the default value
    return f"{amount:.{decimal_places}f}"


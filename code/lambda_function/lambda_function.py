import os
import pyotp

def gen_response(status_code, message):
    body = f"""<!DOCTYPE html>
    <html>
    <style>
        body {{
            font-family: 'Courier New', monospace;
            text-align: center;
            font-size: 10vh;
            text-weight: bold;
        }}
    </style>
    <head>
        <title>2FA</title>
    </head>
    <body>
        <p>{message}</p>
    </body>
    </html>"""
    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'text/html'
        },
        'body': body
    }

def lambda_handler(event, context):
    if 'queryStringParameters' not in event:
        return gen_response(400, 'Missing query string parameters')
    if 'secret' not in event['queryStringParameters']:
        return gen_response(400, 'Missing secret')
    secret = event['queryStringParameters']['secret']
    if secret != "$herl0ckHolm3s":
        return gen_response(403, 'Invalid secret')
    totp = pyotp.TOTP(os.environ['TOTP_SECRET'])
    return gen_response(200, totp.now())

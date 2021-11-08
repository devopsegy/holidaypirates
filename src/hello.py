from flask import Flask
import boto3
from datetime import datetime

app = Flask(__name__)
dynamodb = boto3.resource('dynamodb', region_name='us-west-2')
table = dynamodb.Table('hello_name')

def add_entry(first_name, time_now):
    table.put_item(
        Item={
            'first_name': first_name,
            'time': time_now,
        }
    )

@app.route("/")
def hello():
    return f'It is working\n'

@app.route("/hello/<first_name>")
def hello_name(first_name):
    add_entry(first_name, str(datetime.now()))
    return f'Hello {first_name}\n'


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)

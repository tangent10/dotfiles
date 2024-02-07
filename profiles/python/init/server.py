#!/usr/bin/env python

from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
import io
import os

server = Flask(__name__)
cors_config={ 'allow_headers': '*' }
CORS(server, allow_headers='*')

base_uri='localhost:5001'

@server.get('/health')
def health_check():
    return { 'message': 'UP' }, 200

if __name__ == '__main__':
    server.run(host='0.0.0.0', port=int(os.environ.get('PORT',5001)))

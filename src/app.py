#!/usr/bin/python3 
# 

import socket
from flask import Flask
from datetime import datetime
import time
import os.path
import logging

app = Flask(__name__)

def lock_file_name():
    lock_file_name = '/tmp/hello.lock'
    return lock_file_name

@app.route("/")
def main():
    time_now = datetime.now()
    hostname = socket.gethostname() + '.foo.com'
    response_body = "<h1 style='color:blue'>" + \
        hostname + "</h1>" + \
        '<p>' + str(time_now) + "</p>"
    return response_body


@app.route("/status")
def healthcheck():
    if os.path.isfile(lock_file_name()):
        status_msg = "<h1>Ok </h1>"
    else:
        #time.sleep(5)
        status_msg = "<h1>Not ready</h1>"
        file_lock = open(lock_file_name(), "x")
        file_lock.write("locked")
        return status_msg, 503
    return status_msg

@app.errorhandler(404)
def not_found(error):
    return "Error",404

if __name__ == "__main__":
    if os.path.isfile(lock_file_name()):
        os.remove(lock_file_name())
    app.run(host='0.0.0.0')

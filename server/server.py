from pymongo import MongoClient
from utils.database import Database
from utils.date import *
from flask import Flask, request

app = Flask(__name__)


@app.route("/", methods=["GET"])
def index():
    return "cota server is now running"


if __name__ == "__main__":
    app.run(port=9001, debug=True)
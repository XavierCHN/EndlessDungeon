from pymongo import MongoClient, DESCENDING
from utils.date import *

client = MongoClient("mongodb://admin:jIlI412176199@192.168.1.233:27017")
db = client.cota

class Database:
    @staticmethod
    def tradedb():
        return db['trades']

    @staticmethod
    def playerdb():
        return db['players' + get_season()]

    @staticmethod
    def gamedb():
        return db['games' + get_season()]

    @staticmethod
    def new_player(steamid):
        Database.playerdb().insert({
            "steamid": steamid,
            "register": time_stamp(),
        })

    @staticmethod
    def is_player_exists(steamid):
        return not Database.playerdb().find_one({"steamid": steamid}) is None

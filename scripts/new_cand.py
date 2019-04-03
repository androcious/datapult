import query_help as qry
import fill
import trends
import time

import mysql.connector as mariadb

mariadb_connection = mariadb.connect(user='root', password='datapult49', database='gtep_test')
cursor = mariadb_connection.cursor()

def reset_query():
    one_week = datetime.datetime.today() - datetime.timedelta(days=7)
    q_string = """
        DELETE FROM query_dup
        WHERE qdate > {};
        """.format(one_week)
    try:
        cursor.execute(q_string)
    except Exception as e:
        print("Error deleting old records from db: {}".format(e))



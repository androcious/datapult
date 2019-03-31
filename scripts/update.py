import time
import sys
import mysql.connector as mariadb

mariadb_connection = mariadb.connect(user='root', password='datapult49', database='test')
cursor = mariadb_connection.cursor()

try:
    datetest = sys.argv[1]
except:
    print("error")
    sys.exit(1)

fake_insert = """
    INSERT INTO test_table
    (column1)
    VALUES
    
"""

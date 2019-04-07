import datetime
import time
import pdb
import sys

import trends
import query_help as qry

import mysql.connector as mariadb
from trends import REQUESTS

mariadb_connection = mariadb.connect(user='root', password='datapult49', database='gtep_test')
cursor = mariadb_connection.cursor()

today = datetime.datetime.today()

def insert_data(cand, score, cid, state, date):
    q_string = """
        INSERT INTO query_dup
        (qid, phrase, cid, state_code, amount, qdate)
        VALUES
        (NULL, "{}", {}, "{}", {}, "{}");
        """.format(cand, cid, qry.trim_state(state), score, date.strftime("%Y-%m-%d"))
    print(q_string)
    try:
        cursor.execute(q_string)
    except Exception as e:
        print("ERROR inserting the following query:\n{}\n\n{}\n\n".format(q_string, e))
    

### Fill the db with trend data from date passed in to today
def fill(date_start_str):
    try:
        if date_start_str == "today":
            date_start = today
        else:
            date_start = datetime.datetime.strptime(date_start_str, "%Y-%m-%d")
    except Exception as e:
        print("Error parsing date: {}".format(e))

    while date_start <= today:
        print("Computing trend data for {}...\n\n".format(date_start))
        cand_list = qry.get_candidates()
        states = qry.get_states()
        cand_map = qry.cand_to_map(cand_list)
        for state in states:
            print("current request load: {}".format(REQUESTS))
            request_failed = True
            while request_failed:
                request_failed = False
                try:
                    averages = trends.normalized_averages(cand_list, state, date_start)
                except Exception as e:
                    print("Received error: {}".format(e))
                    print("Rate limit hit. Waiting an hour before trying again...")
                    request_failed = True
                    sleep(3600)

            for cand, score in averages.iteritems():
                try:
                    insert_data(cand, score, cand_map[cand], state, date_start)
                except KeyError:
                    pass
            mariadb_connection.commit()
            time.sleep(60)
        date_start = date_start + datetime.timedelta(days=1)

if __name__ == "__main__":
    date_start_str = sys.argv[1]
    fill(date_start_str)

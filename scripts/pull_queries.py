import time
from constants import *

import mysql.connector as mariadb

import pytrends.request as requests
from pytrends.request import TrendReq
pytrends = TrendReq(hl='en-US', tz=360)

PRIMARY_QID = 0
CAND_ID = {
    'kamala harris': 0,
    'pete buttigieg': 1,
    'bernie sanders': 2,
    'elizabeth warren': 3,
    'cory booker': 4,
    'kirsten gillibrand': 5,
    'amy klobuchar': 6,
    'jay inslee': 7,
    'julian castro': 8,
}

mariadb_connection = mariadb.connect(user='root', password='datapult49', database='gtep_test')
cursor = mariadb_connection.cursor()

def get_related_queries(cand_name, state):
    """Called for each cand in each state. Returns list of all relevant queries."""
    queries = [ cand_name ]
    # get all related queries
    try:
	pytrends.build_payload([cand_name], cat=0, timeframe='today 3-m', geo='US-{}'.format(state), gprop='')
	query_obj = pytrends.related_queries()
        query_dict = query_obj[cand_name]['top'].to_dict()['query']
        for _, q in query_dict.iteritems():
            if cand_name in q:
                queries.append(q)
    except Exception as e:
        pass

    return queries

def all_queries(states=STATES):
    global PRIMARY_QID
    for state in states:
        for cand in CAND_LIST:
            queries = get_related_queries(cand, state)[:5]
            pytrends.build_payload(queries, cat=0, timeframe='today 3-m', geo='US-{}'.format(state), gprop='')
            data = pytrends.interest_over_time()
	    for index, row in data.iterrows():
	        for query in queries:
		# cursor.execute("INSERT INTO employees (first_name,last_name) VALUES (%s,%s)", (first_name, last_name))
		    if row[query] > 0:
			q_string = """
			   INSERT INTO query
			   (qid, phrase, cid, state_code, amount, qdate)
			   VALUES
			   ({}, "{}", {}, "{}", {}, "{}");
			""".format(PRIMARY_QID, query, CAND_ID[cand], state, row[query], index)
			print("attempting query:\n{}".format(q_string))
			try:
			   cursor.execute(q_string)
			except Exception as e:
			   print('ERROR: {}'.format(e))
			   pass
		    PRIMARY_QID = PRIMARY_QID + 1
	time.sleep(60)


if __name__ == "__main__":
    all_queries()

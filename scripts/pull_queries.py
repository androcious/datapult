import time
import pdb
import sys
from constants import *

import mysql.connector as mariadb

import pytrends.request as requests
from pytrends.request import TrendReq
pytrends = TrendReq(hl='en-US', tz=360)

PRIMARY_QID = 0
mariadb_connection = mariadb.connect(user='root', password='datapult49', database='gtep_test')
cursor = mariadb_connection.cursor()

def get_states():
    """
    Pulls state info from the state table.
    Returns a list of states.
    """
    q_string = """
	SELECT state_code FROM state;
    """
    try:
	cursor.execute(q_string)
        result = cursor.fetchall()
    except:
	print("ERROR: Could not fetch state data")
	sys.exit()

    # Parse and transform into list.
    state_list = []
    for tup in result:
        state_list.append("{}".format(tup[0]))
    return state_list

def get_candidates():
    """
    Pulls candidate info from the candidate table.
    Returns a list of candidate firstname+lastname in format: ['first last'].
    """
    q_string = """
	SELECT first_name, last_name, cid FROM candidate;
    """
    try:
	cursor.execute(q_string)
        result = cursor.fetchall()
    except:
	print("ERROR: Could not fetch candidate data")
	sys.exit()

    # Parse and transform into list.
    cand_list = []
    for tup in result:
        cand_list.append(["{} {}".format(tup[0], tup[1]), tup[2]])
    print("ALL CANDIDATES IN DATABASE:\n{}".format(cand_list))
    return cand_list

def get_related_queries(cand_name, state):
    """
    Called for each cand in each state.
    Returns list of all relevant queries.
    """
    # If there aren't any 'related' queries, at least use the name itself.
    queries = [ cand_name ]

    # Get all related queries.
    try:
	pytrends.build_payload([cand_name], cat=0, timeframe='today 3-m', geo='US-{}'.format(state), gprop='')
	query_obj = pytrends.related_queries()
        query_dict = query_obj[cand_name]['top'].to_dict()['query']
        for _, q in query_dict.iteritems():
            if cand_name in q:
                queries.append(q)
    except Exception as e:
        print("ERROR: Error getting related queries for {} in {}: {}".format(cand_name, state, e))

    return queries

def all_queries_in_state(state, cand_list, date_begin=None, date_end=None):
    """
    For a given state and candidate list, populate the query table with
    all queries related to each candidate in that state.
    """
    global PRIMARY_QID
    for cand in cand_list:
        queries = get_related_queries(cand[0], state)[:5]

        # default if no range provided: lookback 1 day
        if date_begin is None:
	    pytrends.build_payload(queries, cat=0, timeframe='now 1-d', geo='US-{}'.format(state), gprop='')
        # get data from throughout range
        else:
	    pytrends.build_payload(queries, cat=0, timeframe='{} {}'.format(date_begin, date_end), geo='US-{}'.format(state), gprop='')

        data = pytrends.interest_over_time()
        for date, row in data.iterrows():
	    for query in queries:
	        if row[query] > 0:
		    q_string = """
		        INSERT INTO query
		        (qid, phrase, cid, state_code, amount, qdate)
		        VALUES
		        ({}, "{}", {}, "{}", {}, "{}");
		    """.format(PRIMARY_QID, query, cand[1], state, row[query], date)
		    print("attempting insert:\n{}".format(q_string))
		    try:
		        cursor.execute(q_string)
                        PRIMARY_QID = PRIMARY_QID + 1
		    except Exception as e:
		        print('ERROR: Error processing queries for {} in {}: {}'.format(cand, state, e))
		        pass

def all_queries(date_begin=None, date_end=None):
    states = get_states()
    cand_list = get_candidates()
    for state in states:
	try:
	    all_queries_in_state(state, cand_list, lookback, date_begin, date_end)
        except Exception as e:
	    print('ERROR: Error handling queries for {}: {}'.format(state, e))
	    pass
	mariadb_connection.commit()
	time.sleep(60)


if __name__ == "__main__":
    date_begin = None
    date_end = None
    try:
        date_begin = sys.argv[1]
        date_end = sys.argv[2]
    except:
        # no dates passed in
        pass

    all_queries(date_begin, date_end)

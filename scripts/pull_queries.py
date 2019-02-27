from constants import *

import pytrends.request as requests
from pytrends.request import TrendReq
pytrends = TrendReq(hl='en-US', tz=360)


def get_related_queries(cand_name, state):
    """Called for each cand in each state. Returns list of all relevant queries."""
    queries = [ cand_name ]
    pytrends.build_payload([cand_name], cat=0, timeframe='now 1-d', geo='US-{}'.format(state), gprop='')
    # get all related queries
    query_obj = pytrends.related_queries()
    try:
        query_dict = query_obj[cand_name]['top'].to_dict()['query']
        for _, q in query_dict.iteritems():
            if cand_name in q:
                queries.append(q)
    except Exception as e:
        pass

    return queries

def all_queries(states=STATES):
    for state in states:
        print('\n\n\n------------------------------------------')
        print('{} SEARCHES'.format(state))
        print('------------------------------------------')
        for cand in CAND_LIST:
            print('\n\n\nSEARCHES FOR {}'.format(cand.upper()))
            queries = get_related_queries(cand, state)[:5]
            print('Queries: {}'.format(queries))
            pytrends.build_payload(queries, cat=0, timeframe='now 1-d', geo='US-{}'.format(state), gprop='')
            data = pytrends.interest_over_time()
            for query in queries:
                try:
                    print("{}: {} searches".format(query, data[query].sum()))
                except:
                    print("No searches for {} in {}".format(query, state))
            # we can maybe use pandas sum function here to make it more efficient
            # sum the data in each "column" where a column is a query


if __name__ == "__main__":
    all_queries()

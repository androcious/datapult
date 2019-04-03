import time
import datetime
import pdb
import sys

import pytrends.request as requests
from pytrends.request import TrendReq
pytrends = TrendReq(hl='en-US', tz=360)

import query_help as qry

REQUESTS = 0

def compute_relative_trends(state, cand1, cand2, date):
    global REQUESTS
    """
    Compute the relative average trend for the past week
    for candidates 1 and 2 in given state.
    """
    try:
        date_start = (date - datetime.timedelta(days=7)).strftime("%Y-%m-%d")
        date_end = date.strftime("%Y-%m-%d")
    except ValueError as e:
        raise ValueError("Error parsing dates: {}".format(e))

    try:
        pytrends.build_payload(
                 [cand1, cand2], cat=0, timeframe='{} {}'.format(date_start, date_end), \
                 geo='{}'.format(state), gprop='')
    except Exception as e:
        print("Error building payload for {} and {} in {}: {}".format(cand1, cand2, state, e))
        raise(e)
    REQUESTS = REQUESTS + 1
    if REQUESTS == 1300:
        print("WARNING: HIT THRESHOLD OF 1300 REQUESTS. SLEEPING FOR A WHILE")
        time.sleep(14400)
        REQUESTS = 0
    data = pytrends.interest_over_time()
    # average weekly trend computation
    cand1_tot = cand2_tot = 0
    for _, row in data.iterrows():
        cand1_tot = cand1_tot + row[cand1]
        cand2_tot = cand2_tot + row[cand2]

    return cand1_tot / 7, cand2_tot / 7
    
def normalized_averages(cand_list, state, date):
    # { cand[i]_name: [cand[0]_score, cand[i]_score] }
    relative_score = {}
    # { cand[i]_name: final_score }
    normalized_score = {}

    max_score = 0
    max_cand = None
    
    for i in range(1, len(cand_list)):
        zero_score, rel_score = compute_relative_trends(state, cand_list[0][0], cand_list[i][0], date)
        if rel_score > max_score:
            max_score = rel_score
            max_cand = cand_list[i][0]
        relative_score[cand_list[i][0]] = [zero_score, rel_score]

    normalized_score[max_cand] = max_score
    try:
        normalized_score[cand_list[0][0]] = relative_score[max_cand][0]
    except Exception as e:
        # there is no query data in this state for this week
        pass

    for i in range(1, len(cand_list)):
        if max_cand is None:
            normalized_score[cand_list[i][0]] = 0

        if cand_list[i][0] not in normalized_score:
            try:
                normalized_score[cand_list[i][0]] = relative_score[max_cand][0] * \
                                                    relative_score[cand_list[i][0]][1] / \
                                                    relative_score[cand_list[i][0]][0]
            except ZeroDivisionError as e:
                normalized_score[cand_list[i][0]] = relative_score[cand_list[i][0]][1]

    return normalized_score


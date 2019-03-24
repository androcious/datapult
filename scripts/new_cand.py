import time
import pull_queries as pq
import mysql.connector as mariadb

states = pq.get_states()
cand_list = pq.get_candidates()

mariadb_connection = mariadb.connect(user='root', password='datapult49', database='gtep_test')
cursor = mariadb_connection.cursor()

new_cand = []
for cand in cand_list:
    # Get count of queries for candidate to see if this is the new one
    query = """
        SELECT COUNT(*)
        FROM query
        WHERE phrase LIKE "%{}%"
    """.format(cand[0])
    print('searching for {}'.format(cand[0]))
    try:
        cursor.execute(query)
        result = cursor.fetchall()
    except Exception as e:
        print("ERROR retrieving candidate count for {}".format(cand[0]))
    if result[0][0] == 0:
        new_cand.append(cand)

for state in states:
    # get last week of data for this cand
    pq.all_queries_in_state(state, new_cand, lookback=7)
    mariadb_connection.commit()
    time.sleep(60)

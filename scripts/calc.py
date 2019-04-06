import sys
import pandas
import datetime

import mysql.connector as mariadb

mariadb_connection = mariadb.connect(user='root', password='datapult49', database='gtep_test')
cursor = mariadb_connection.cursor()

def get_query(date):
    """
    Pulls query table winner (cid), state_code, and qdate
    Returns grouped data for summary table
    """
    q_string = """
	SELECT cid, state_code, sum(amount), qdate
    FROM query_dup
    WHERE qdate = '{}'
    GROUP BY cid, state_code, qdate;
    """.format(date)
    try:
        cursor.execute(q_string)
        result = cursor.fetchall()
    except:
        print("ERROR: Could not fetch summary data")
        sys.exit()
    
    # Parse and transform into list.
    summary_list = []
    for tup in result:
        summary_list.append(["{}".format(tup[0]), "{}".format(tup[1]), 
                             "{}".format(tup[2]), "{}".format(tup[3])])
    
    # Convert to pandas dataframes
    queries = pandas.DataFrame.from_records(summary_list)
    queries.columns = ['cid', 'state_code', 'amount', 'sdate']
    queries['cid'] = queries['cid'].astype(int)
    queries['state_code'] = queries['state_code'].astype(str)
    queries['amount'] = queries['amount'].astype(int)
    queries['sdate'] = queries['sdate'].astype(str)
    return queries
    
def get_state_delegate():
    """
    Pulls state table state_code and delegates_at_play
    Returns data to help calculate summary table
    """
    q_string = """
    SELECT state_code, delegates_at_play
    FROM state;
    """
    try:
        cursor.execute(q_string)
        result = cursor.fetchall()
    except:
        print("ERROR: Could not fetch state delegate data")
        sys.exit()

    # Parse and transform into list.
    delegate_list = []
    for tup in result:
        delegate_list.append(["{}".format(tup[0]), "{}".format(tup[1])])
        
    delegates = pandas.DataFrame.from_records(delegate_list)
    delegates.columns = ['state_code', 'delegates_at_play']
    delegates['delegates_at_play'] = delegates['delegates_at_play'].astype(int)
    delegates['state_code'] = delegates['state_code'].astype(str)
    
    return delegates

def get_max_sid():   
    """
    Gets max sid from summary table in database and assigns sids to 
    query table before committing. 
    """
    # Now I need to get the max sid so I can continue to increment
    q_string = """
    SELECT max(sid)
    FROM summary;
    """
    try:
        cursor.execute(q_string)
        result = cursor.fetchall()
    except:
        print("ERROR: Could not fetch max sid from summary table")
        sys.exit()
    
    if result[0][0] is None:
        result = 0
    else:
        result = result[0][0]

    return result

def get_delegate_proportion(date):
    """
    Combines query and state tables and calculates delegate proportion to 
    Google searches.  
    Returns a table of states and proportions. 
    """
    # Pull data from database
    queries = get_query(date)
    delegates = get_state_delegate() 
    
    # Create summary of queries by state and join to state table
    state_queries = queries.groupby('state_code')['amount'].sum().reset_index()
    delegates = pandas.merge(delegates, state_queries, on='state_code', how='inner')
    
    # Create proportion column for how many delegates each Google query is worth
    delegates['proportion'] = delegates['delegates_at_play'] / delegates['amount'] 
    del delegates['delegates_at_play']
    del delegates['amount']
    
    return delegates
    

def create_summary(date):
    """
    Combines query and state tables and calculates delegate proportion to 
    Google searches.  Assigns sid.
    """
    # Pull data from database
    queries = get_query(date)
    delegates = get_delegate_proportion(date)
    max_sid = get_max_sid()
    
    # Join this proportion column back to queries table
    queries = pandas.merge(queries, delegates, on='state_code', how='left')
    queries = queries[queries['amount'] > 0]
    queries['amount'].fillna(0, inplace=True)
    queries['delegates_won'] = queries['amount'] * queries['proportion']
    queries['delegates_won'] = queries['delegates_won'].astype(int)
    
    # I don't love the rounding at this point because the total number of
    # delegates may not add up to the total number of available delgates.
    # We can fix this later...

    # Assign sid and clean up data frame
    queries = queries.reset_index()
    queries['sid'] = queries.index + max_sid + 1
    del queries['index']
    del queries['amount']
    del queries['proportion']

    queries = queries[['sid', 'cid', 'state_code', 'sdate', 'delegates_won']]
    
    return queries
    
def commit_summary(date):    
    """
    Commits to database.  
    """
    queries = create_summary(date)
    
    for index, row in queries.iterrows():
        # Create SQL string to insert rows 
        q_string = """
        INSERT INTO summary
		(sid, cid, state_code, sdate, delegates_won)
		VALUES
		({}, {}, "{}", "{}", {});
		""".format(row['sid'], row['cid'], row['state_code'], row['sdate'],
        row['delegates_won'])
        # print("attempting insert:\n{}".format(q_string))
        try:
            cursor.execute(q_string)
        except Exception as e:
            print('ERROR: Error processing queries for {}: {}'.format(row['sid'], e))
            pass
    
    mariadb_connection.commit()
    
def get_summary(date):
    """
    Pulls last seven days of summary table data in order to feed data into
    update_state_winner() and update_candidate_delegates() functions.
    Returns a summary table.
    """
    
    date2 = datetime.datetime.strptime(date, '%Y-%m-%d') - datetime.timedelta(days=7)
    date2 = datetime.datetime.strftime(date2, '%Y-%m-%d')
    
    q_string = """
	SELECT cid, state_code, SUM(delegates_won)
    FROM summary
    WHERE sdate <= '{}' AND sdate >= '{}'
    GROUP BY cid, state_code;
    """.format(date, date2)
    try:
        cursor.execute(q_string)
        result = cursor.fetchall()
    except:
        print("ERROR: Could not fetch summary data")
        sys.exit()

    # Parse and transform into list.
    summary_list = []
    for tup in result:
        summary_list.append(["{}".format(tup[0]), "{}".format(tup[1]), 
                             "{}".format(tup[2])])
    
    # Convert to pandas dataframes
    summary = pandas.DataFrame.from_records(summary_list)
    summary.columns = ['cid', 'state_code', 'delegates_won']
    summary['cid'] = summary['cid'].astype(int)
    summary['state_code'] = summary['state_code'].astype(str)
    summary['delegates_won'] = summary['delegates_won'].astype(int)
    
    return summary
    
def update_state_winner(date):
    """
    Finds candidate with the max delegates for each state.
    Updates state table with the candidate with the most delegates.
    """
    state_winner = get_summary(date)
    states = get_state_delegate()[['state_code']]
    
    winner = state_winner[['cid', 'delegates_won']]
    state_winner = state_winner.groupby('state_code')['delegates_won'].max().reset_index()
    state_winner = pandas.merge(state_winner, winner, on='delegates_won', how='left')
    
    # If there is a tie, we keep the first winner by cid in ascending order
    state_winner = state_winner.drop_duplicates(['state_code'], keep='first')
    
    states = pandas.merge(states, state_winner, on='state_code', how='left')
    del states['delegates_won']
    states['cid'].fillna(99, inplace=True)
    states['cid'] = states['cid'].astype(int)
    
    # I couldn't think of a good way to handle a state_code that had absolutely
    # no searches so I made it a cid 99 for now.
    
    for index, row in states.iterrows():
        # Create SQL string to insert rows 
        q_string = """
        UPDATE state
        SET current_winner = {}
        WHERE state_code = '{}';
		""".format(row['cid'], row['state_code'])
        # print("attempting insert:\n{}".format(q_string))
        try:
            cursor.execute(q_string)
        except Exception as e:
            print('ERROR: Error processing queries for {}: {}'.format(row['state_code'], e))
            pass
    
    mariadb_connection.commit()  
    
def get_candidates():
    """
    Retrieves the candidates from the database.
    Returns the list of cids.
    """
    
    q_string = """
	SELECT cid
    FROM candidate
    """
    try:
        cursor.execute(q_string)
        result = cursor.fetchall()
    except:
        print("ERROR: Could not fetch candidate data")
        sys.exit()

    # Parse and transform into list.
    candidate_list = []
    for tup in result:
        candidate_list.append(["{}".format(tup[0])])
    
    # Convert to pandas dataframes
    candidates = pandas.DataFrame.from_records(candidate_list)
    candidates.columns = ['cid']
    candidates['cid'] = candidates['cid'].astype(int)
        
    return candidates
    
def update_candidate_delegates(date):
    """
    Finds average number of delegates for each candidate.
    Updates candidate table with total number of average delegates won.
    """
    delegates = get_summary(date)
    candidates = get_candidates()
    
    delegates = delegates.groupby('cid')['delegates_won'].sum().reset_index()
    delegates['delegate_count'] = delegates['delegates_won'] / 7
    delegates['delegate_count'] = delegates['delegate_count'].astype(int)
    del delegates['delegates_won']
    
    candidates = pandas.merge(candidates, delegates, on='cid', how='left')
    
    # If there the candidate has no searches, then the total delegates equal 0
    candidates['delegate_count'].fillna(0, inplace=True)
       
    for index, row in candidates.iterrows():
        # Create SQL string to insert rows 
        q_string = """
        UPDATE candidate
        SET delegate_count = {}
        WHERE cid = {};
		""".format(row['delegate_count'], row['cid'])
        # print("attempting insert:\n{}".format(q_string))
        try:
            cursor.execute(q_string)
        except Exception as e:
            print('ERROR: Error processing delegates for {}: {}'.format(row['cid'], e))
            pass
    
    mariadb_connection.commit() 
    
def update_all():
    """
    Deletes everything in summary table.
    Determines date range to use from query table in database.
    Pulls in all new summary data using commit_summary() on a loop.
    Updates state and candidate table based on the most recent date from 
    query table in database using update_state_winner() and 
    update_candidate_delegates().
    """
    
    # Delete everything in summary table
    q_string = """
	TRUNCATE summary;
    """
    try:
        cursor.execute(q_string)
    except:
        print("ERROR: Could not delete summary table data")
        sys.exit()
    print("Summary table truncated.")
    
    # Determine date range to use from query table in database
    q_string = """
    SELECT max(qdate), min(qdate)
    FROM query_dup;
    """
    try:
        cursor.execute(q_string)
        result = cursor.fetchall()
    except:
        print("ERROR: Could not fetch dates from query table")
        sys.exit()
    
    dates = pandas.date_range(start=result[0][1], end=result[0][0])
    date1 = datetime.datetime.strftime(result[0][0], '%Y-%m-%d')
    date2 = datetime.datetime.strftime(result[0][1], '%Y-%m-%d')
    
    # Pull in all new summary data using commit_summary() on a loop.
    print('Please be patient, populating summary table from {} to {}.'.format(date2, date1))
    
    for date in dates:
        try:
            pulldate = datetime.datetime.strftime(date, '%Y-%m-%d')
            commit_summary(pulldate)
        except:
            print("ERROR: Missing date {} from database.".format(pulldate))
            pass
    
    print('Added summary table data for date range: {} to {}.'.format(date2, date1))
    
    # Update state and candidate table based on the most recent date from
    # query table in database.
    update_state_winner(date1)
    print('Updated state table with candidate winner using 7 day average.')
    update_candidate_delegates(date1)
    print('Updated average number of delegates per candidate over 7 days.')
    
    print('Complete.')

if __name__ == "__main__":
    update_all()

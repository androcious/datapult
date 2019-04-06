import sys
import pandas

import mysql.connector as mariadb

mariadb_connection = mariadb.connect(user='root', password='datapult49', database='gtep_test')
cursor = mariadb_connection.cursor()

def create_delegate_file():
    """
    Pulls state table from database
    Saves state table to local file structure as a csv file
    """
    q_string = """
	SELECT cid, first_name, last_name, sdate, SUM(delegates_won)
    FROM summary
    LEFT JOIN (SELECT cid AS ccid, first_name, last_name
               FROM candidate) c
    ON summary.cid = c.ccid
    GROUP BY cid, sdate;
    """
    try:
        cursor.execute(q_string)
        result = cursor.fetchall()
    except:
        print("ERROR: Could not fetch delegate summary data")
        sys.exit()

    # Parse and transform into list.
    delegateLine_list = []
    for tup in result:
        delegateLine_list.append(["{}".format(tup[0]), "{}".format(tup[1]), 
                             "{}".format(tup[2]), "{}".format(tup[3]),
                             "{}".format(tup[4])])
    
    # Convert to pandas dataframes
    delegateLine = pandas.DataFrame.from_records(delegateLine_list)
    
    if delegateLine.empty:
        print('Summary table was empty, not writing over delegateLine.csv')
    else:
        delegateLine.columns = ['cid', 'first_name', 'last_name', 'sdate', 'amount']
        delegateLine['cid'] = delegateLine['cid'].astype(int)
        delegateLine['first_name'] = delegateLine['first_name'].astype(str)
        delegateLine['last_name'] = delegateLine['last_name'].astype(str)
        delegateLine['sdate'] = delegateLine['sdate'].astype(str)
        delegateLine['amount'] = delegateLine['amount'].astype(int)
        # Now I need to change the format to match what is needed
        # Need columns as date and then name of each candidate
        # Need date as YMD like 20111001
        delegateLine['name'] = delegateLine[['first_name', 'last_name']].apply(
                lambda x: ' '.join(x), axis=1)
        del delegateLine['first_name']
        del delegateLine['last_name']
        del delegateLine['cid']
        delegateLine = delegateLine.pivot(index='sdate', columns='name')
        delegateLine.reset_index(level=0, inplace=True)
        delegateLine['sdate'] = delegateLine['sdate'].astype(str)
        delegateLine.sdate = delegateLine.sdate.str.slice(0,10)
        return delegateLine
        #delegateLine.to_csv('./trending2020/data/candidate_summary.tsv', sep='\t', encoding='utf-8')
        #print('Updated delegateLine.csv')
    
def write_all():
    create_delegate_file()

if __name__ == "__main__":
    write_all()

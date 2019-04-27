import sys
import pandas
import json
from copy import deepcopy

import mysql.connector as mariadb

mariadb_connection = mariadb.connect(user='root', password='datapult49', database='gtep_test')
cursor = mariadb_connection.cursor()
targetFile = "candidate_summary.tsv"
targetFile2 = "us-states2.js"
targetPath = "/opt/tomcat/webapps/trending2020/data/"

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
        delegateLine_list.append([tup[1], tup[2], tup[3], tup[4]])
  
    # Convert to pandas dataframes
    delegateLine = pandas.DataFrame.from_records(delegateLine_list)
    
    if delegateLine.empty:
        print('Summary table was empty, not writing over delegateLine.csv')
    else:
        delegateLine.columns = ['first_name', 'last_name', 'sdate', 'amount']
        delegateLine['first_name'] = delegateLine['first_name'].astype(str)
        delegateLine['last_name'] = delegateLine['last_name'].astype(str)
        delegateLine['sdate'] = delegateLine['sdate'].astype(str)

        # Now I need to change the format to match what is needed
        # Need columns as date and then name of each candidate
        delegateLine['name'] = delegateLine[['first_name', 'last_name']].apply(
                lambda x: ' '.join(x), axis=1)
        del delegateLine['first_name']
        del delegateLine['last_name']
        delegateLine = delegateLine.pivot(index='sdate', columns='name', values='amount')
        delegateLine.reset_index(level=0, inplace=True)
        # Need date as YMD like 20111001
        delegateLine['sdate'] = delegateLine['sdate'].astype(str)
        delegateLine.sdate = delegateLine.sdate.str.slice(0,10)
        delegateLine.sdate = delegateLine.sdate.str.replace("-","")
        # Capitalize Candidate Name
        delegateLine.columns = map(str.title, delegateLine.columns)
        # Rename the first column to match requirement for ploting function
        delegateLine.rename(columns={'Sdate': 'date'}, inplace=True)

        # To return calculated dataframe, uncomment the line below
        # return delegateLine
        
        # After clean data i.e. remove unwanted row/col, use right header to match required format of plotting fucntion
        # Write to TSV file
        delegateLine.to_csv(targetPath+targetFile, sep='\t', encoding='utf-8', index=False)

        print('--Updated ' + targetFile)
    
def create_us_states_file():
    """
    Pulls state and candidate tables from database
    Joins to map file and saves to local file structure as a js file
    """
    q_string = """
    SELECT state_code, name, cid, first_name, last_name, type_of_primary, 
        delegates_at_play, population 
    FROM state
    LEFT JOIN (SELECT cid, first_name, last_name 
               FROM candidate) c 
    ON state.current_winner = c.cid;
    """
    try:
        cursor.execute(q_string)
        result = cursor.fetchall()
    except:
        print("ERROR: Could not fetch state or candidate data")
        sys.exit()

    # Parse and transform into list.
    state_list = []
    for tup in result:
        state_list.append([tup[0], tup[1], tup[2], tup[3], tup[4], tup[5],
                           tup[6], tup[7]])
  
    # Convert to pandas dataframes
    states = pandas.DataFrame.from_records(state_list)
    
    if states.empty:
        print('State table was empty, not writing over us-states2.js')
    else:
        states.columns = ['code', 'state', 'cid', 'first_name', 'last_name', 
                          'typeprim', 'delegates', 'population']
        states['id'] = states['code'].astype(str)
        states['state'] = states['state'].astype(str)
        states['first_name'] = states['first_name'].astype(str)
        states['last_name'] = states['last_name'].astype(str)
        states['typeprim'] = states['typeprim'].astype(str)
        states['delegates'] = states['delegates'].astype(int)
        states['population'] = states['population'].astype(int)

        # Now I need to change the format to match what is needed
        # Need name of each candidate
        states['flname'] = states[['first_name', 'last_name']].apply(
                lambda x: ' '.join(x), axis=1)
        del states['first_name']
        del states['last_name']
        del states['code']
        
        # Capitalize Candidate Name
        states.flname = states.flname.str.title()
    
        with open('us-states.json') as json_file:
            a = json.load(json_file)

        c = []

        for fC, f in a.items():
            if fC == 'features':
                for i in range(len(f)):
                    listItems = f[i]
                    temp = deepcopy(listItems)
                    for k, v in listItems.items():
                        if k == 'id':
                            temp2 = states[states.id == v]
                            temp['cid'] = temp2['cid'].iloc[0]
                            temp['state'] = temp2['state'].iloc[0]
                            temp['flname'] = temp2['flname'].iloc[0]
                            temp['typeprim'] = temp2['typeprim'].iloc[0]
                            temp['delegates'] = int(temp2['delegates'].iloc[0])
                            temp['population'] = int(temp2['population'].iloc[0])
                            c.append(temp)
        
        a['features'] = c
         
        myString = 'var statesData = ' + json.dumps(a)
           
        file = open(targetPath+targetFile2, 'w')
        file.write(myString)
        file.close()

        print('--Updated ' + targetFile2)    
    
def write_all():
    create_delegate_file()
    create_us_states_file()

if __name__ == "__main__":
    write_all()

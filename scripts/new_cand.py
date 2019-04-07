import sys
import datetime
import mysql.connector as mariadb
import fill as fill_pipeline

conn = mariadb.connect(user='root', password='datapult49', database='gtep_test')
cursor = conn.cursor()

def insert_cand(cname):
    # insert candidate into candidate table
    cname = cname.split(' ')
    if len(cname) != 2:
        print("Error: candidate name must be <first> <last>")
        sys.exit(1)

    q_string = """
        INSERT INTO candidate
        (cid, first_name, middle_name, last_name, delegate_count, nickname, img, color)
        VALUES
        (NULL, "{}", NULL, "{}", 0, NULL, NULL, NULL);
    """.format(cname[0], cname[1])

    print("Executing...\n{}".format(q_string))
    try:
        cursor.execute(q_string)
    except Exception as e:
        print("Error inserting into candidate table: {}".format(e))
        sys.exit(1)

def check_daily_pull():
    # checks to see if the daily pull has occured yet.
    # if it has, we need to clear out that data
    result = 0
    today = datetime.datetime.today()
    str_today = today.strftime("%Y%m%d")
    q_string = """
        SELECT COUNT(*)
        FROM query_dup
        WHERE qdate >= {}
    """.format(str_today)
    print("Checking whether pipeline has been executed today")
    try:
        cursor.execute(q_string)
        result = cursor.fetchall()[0][0]
    except Exception as e:
        print("Error getting number of queries for today.")
        sys.exit(1)
    if result == 0:
        print("Pipeline has not been executed today. Running now with new candidate data...")
        return False
    
    print("Pipeline has already been run for today. Live data with new candidate info will be pulled tomorrow.")
    return True


if __name__ == "__main__":
    try:
        cname = sys.argv[1]
    except:
        print("Error: please pass in a candidate name")
        sys.exit(1)

    insert_cand(cname)
    if not check_daily_pull():
        fill_pipeline.fill("today")

    conn.commit()
    print("Candidate table successfully updated.")

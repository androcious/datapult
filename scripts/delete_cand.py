import sys
import calc
import mysql.connector as mariadb

conn = mariadb.connect(user='root', password='datapult49', database='gtep')
cursor = conn.cursor()

def delete_cand(cname):
    # insert candidate into candidate table
    cname = cname.split(' ')
    if len(cname) != 2:
        print("Error: candidate name must be <first> <last>")
        sys.exit(1)

    # delete from candidate table
    q_string = """
        DELETE FROM candidate
        WHERE first_name = "{}" AND last_name = "{}"
    """.format(cname[0], cname[1])

    print("Executing...\n{}".format(q_string))
    try:
        cursor.execute(q_string)
    except Exception as e:
        print("Error deleting from candidate table: {}".format(e))
        sys.exit(1)

    q_string = """
        DELETE FROM query_dup
        WHERE phrase LIKE "{} {}"
    """.format(cname[0], cname[1])

    print("Executing...\n{}".format(q_string))
    try:
        cursor.execute(q_string)
    except Exception as e:
        print("Error deleting from query table: {}".format(e))
        sys.exit(1)

if __name__ == "__main__":
    try:
        cname = sys.argv[1]
    except:
        print("Error: please pass in a candidate name")
        sys.exit(1)

    delete_cand(cname)
    conn.commit()
    print("Candidate and query table successfully updated.")

    print("Updating summary table")
    calc.update_all()

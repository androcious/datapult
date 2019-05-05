import sys
import calc
import mysql.connector as mariadb

conn = mariadb.connect(user='root', password='datapult49', database='gtep', use_pure=True)
cursor = conn.cursor(prepared=True)

def delete_cand(cname):
    # insert candidate into candidate table
    cname = cname.split(' ')
    if len(cname) != 2:
        print("Error: candidate name must be <first> <last>")
        sys.exit(1)

    # delete from query table
    q_string = """
        DELETE FROM query
        WHERE phrase LIKE %s
    """
    
    cand = cname[0] + ' ' + cname[1]
    input = (cand,)

    print("Executing...\n{}".format(q_string))
    print("Input: {}".format(input))
    try:
        cursor.execute(q_string, input)
    except Exception as e:
        print("Error deleting from query table: {}".format(e))
        sys.exit(1)
    conn.commit()

    # delete from candidate table
    q_string = """
        DELETE FROM candidate
        WHERE first_name = %s AND last_name = %s
    """
    input = (cname[0], cname[1])

    try:
        cursor.execute(q_string, input)
    except Exception as e:
        print("Error deleting from candidate table: {}".format(e))
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

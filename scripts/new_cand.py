import sys

def insert_cand(cname):
    # insert candidate into candidate table
    cname = cname.split(' ')
    if len(cname) != 2:
        print("Error: candidate name must be <first> <last>")
        sys.exit(1)

    q_string = """
        INSERT INTO query_dup
        (cid, first_name, middle_name, last_name, delegate_count, nickname, img, color)
        VALUES
        (NULL, "{}", NULL, "{}", 0, NULL, NULL, NULL);
    """.format(cname[0], cname[1])

    print("Executing...\n{}".format(q_string))

if __name__ == "__main__":
    try:
        cname = sys.argv[1]
    except:
        print("Error: please pass in a candidate name")
        sys.exit(1)

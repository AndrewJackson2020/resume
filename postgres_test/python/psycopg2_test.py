import psycopg2
import logging

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s %(levelname)s %(name)s: %(message)s"
)
logging.getLogger("psycopg2").setLevel(logging.DEBUG)

# Connect to an existing database
conn = psycopg2.connect("postgresql://andrew@example.com/postgres?target_session_attrs=standby")

# Open a cursor to perform database operations
cur = conn.cursor()

# Execute a command: this creates a new table
cur.execute("CREATE TABLE test (id serial PRIMARY KEY, num integer, data varchar);")

cur.fetchone()

conn.commit()

cur.close()
conn.close()

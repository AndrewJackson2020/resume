# Note: the module name is psycopg, not psycopg3
import psycopg
import logging

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s %(levelname)s %(name)s: %(message)s"
)
logging.getLogger("psycopg").setLevel(logging.DEBUG)

# Connect to an existing database
with psycopg.connect("postgresql://andrew@whatever/postgres?target_session_attrs=standby") as conn:

    # Open a cursor to perform database operations
    with conn.cursor() as cur:

        cur.execute("SELECT 1")
        cur.fetchone()
        for record in cur:
            print(record)

        conn.commit()

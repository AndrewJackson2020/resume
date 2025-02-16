import asyncio
import asyncpg
import logging

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s %(levelname)s %(name)s: %(message)s"
)
logging.getLogger("asyncpg").setLevel(logging.DEBUG)

async def run():
    conn = await asyncpg.connect(user='andrew', database='postgres', host='example.com', target_session_attrs='standby')
    values = await conn.fetch(
        'select 1;',
    )
    await conn.close()

asyncio.run(run())

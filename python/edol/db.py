import pandas as pd
from sshtunnel import SSHTunnelForwarder
import os
import json

# edit ini: `gpg ini.json.gpg` 
# encrypt:  `gpg -e -r phil ini.json`
ini = json.loads(os.popen('gpg -d ini.json.gpg').read())

# DB modules
import pymysql
pymysql.install_as_MySQLdb()
import MySQLdb.cursors
from sqlalchemy import create_engine, text

server = SSHTunnelForwarder(
    (ini["server"], 22),
    ssh_pkey    =ini["ssh_pkey"],
    ssh_username=ini["ssh_user"],
    remote_bind_address=('127.0.0.1', 3306)
    )

server.start()
port = str(server.local_bind_port)
print(f'SSH to {ini["server"]} as localhost:{port}')
url = (f'mysql://{ini["User"]}:{ini["Pass"]}@{ini["Host"]}:{port}/{ini["Name"]}')
engine = create_engine(url)

def get_df(sql):
    df = pd.read_sql(text(sql), con=engine)
    return df

print(get_df('SELECT * FROM `forms` LIMIT 10'))

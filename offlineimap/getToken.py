#!/Users/pg/.config/python/p10/bin/python3

# by Phil 01 Jan 23

import json
import subprocess
from pathlib import Path

def getToken(token):
    path = Path(token)
    DECRYPTION_PIPE = ['gpg', '--decrypt']
    token = {}
    sub = subprocess.run(DECRYPTION_PIPE, check=True, input=path.read_bytes(), capture_output=True)
    token = json.loads(sub.stdout)
    return token['access_token']

#!/usr/bin/env python3

"""
Automatic offlineimap and oauth refresh - Phil G - 07 Jan 23
    to be run in background of mutt
    Run offline imap every `refresh` seconds
    If it hangs, kill, kill, kill and retry
    If oauth token expires, refresh token

    SUPERSEEDS crontab and brew service
        for brew service approach, see ~/Documents/txt/22_09_30_OfflineImap.log


Mutt OAuth2 token management script, version 2020-08-07
    Written against python 3.7.3, not tried with earlier python versions.

    Copyright (C) 2020 Alexander Perlis

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License as
    published by the Free Software Foundation; either version 2 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
    02110-1301, USA.
"""

import sys
import json
import argparse
import urllib.parse
import urllib.request
import imaplib
import poplib
import smtplib
import base64
import secrets
import hashlib
import time
from datetime import timedelta, datetime
from pathlib import Path
import socket
import http.server
import subprocess

import time
import os

# The token file must be encrypted because it contains multi-use bearer tokens
# whose usage does not require additional verification. Specify whichever
# encryption and decryption pipes you prefer. They should read from standard
# input and write to standard output. The example values here invoke GPG,
# although won't work until an appropriate identity appears in the first line.

path = Path( "/Users/pg/.config/mutt/oauth_token")
logfile = "~/.config/offlineimap/imap.log"
refresh = 20
verbose = False
ENCRYPTION_PIPE = ['gpg', '--encrypt', '--recipient', 'philipp.grunewald@ouce.ox.ac.uk']
DECRYPTION_PIPE = ['gpg', '--decrypt']

registrations = {
    'google': {
        'authorize_endpoint': 'https://accounts.google.com/o/oauth2/auth',
        'devicecode_endpoint': 'https://oauth2.googleapis.com/device/code',
        'token_endpoint': 'https://accounts.google.com/o/oauth2/token',
        'redirect_uri': 'urn:ietf:wg:oauth:2.0:oob',
        'imap_endpoint': 'imap.gmail.com',
        'pop_endpoint': 'pop.gmail.com',
        'smtp_endpoint': 'smtp.gmail.com',
        'sasl_method': 'OAUTHBEARER',
        'scope': 'https://mail.google.com/',
        'client_id': '',
        'client_secret': '',
    },
    'microsoft': {
        'authorize_endpoint': 'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
        'devicecode_endpoint': 'https://login.microsoftonline.com/common/oauth2/v2.0/devicecode',
        'token_endpoint': 'https://login.microsoftonline.com/common/oauth2/v2.0/token',
        'redirect_uri': 'https://login.microsoftonline.com/common/oauth2/nativeclient',
        'tenant': 'common',
        'imap_endpoint': 'outlook.office365.com',
        'pop_endpoint': 'outlook.office365.com',
        'smtp_endpoint': 'smtp.office365.com',
        'sasl_method': 'XOAUTH2',
        'scope': ('offline_access https://outlook.office.com/IMAP.AccessAsUser.All '
                  'https://outlook.office.com/POP.AccessAsUser.All '
                  'https://outlook.office.com/SMTP.Send'),
        'client_id': '08162f7c-0fd2-4200-a84a-f25a4db0b584',
        'client_secret': 'TxRBilcHdC6WGBee]fs?QR:SJ8nI[g82',
    },
}

def access_token_valid(token):
    '''Returns True when stored access token exists and is still valid at this time.'''
    token_exp = token['access_token_expiration']
    return token_exp and datetime.now() < datetime.fromisoformat(token_exp)


def getToken():
    token = {}
    if path.exists():
        if 0o777 & path.stat().st_mode != 0o600:
            sys.exit('Token file has unsafe mode. Suggest deleting and starting over.')
        try:
            sub = subprocess.run(DECRYPTION_PIPE, check=True, input=path.read_bytes(),
                                 capture_output=True)
            token = json.loads(sub.stdout)
        except subprocess.CalledProcessError:
            sys.exit('Difficulty decrypting token file. Is your decryption agent primed for '
                     'non-interactive usage, or an appropriate environment variable such as '
                     'GPG_TTY set to allow interactive agent usage from inside a pipe?')
    return token


def writetokenfile():
    '''Writes global token dictionary into token file.'''
    if not path.exists():
        path.touch(mode=0o600)
    if 0o777 & path.stat().st_mode != 0o600:
        sys.exit('Token file has unsafe mode. Suggest deleting and starting over.')
    sub2 = subprocess.run(ENCRYPTION_PIPE, check=True, input=json.dumps(token).encode(),
                          capture_output=True)
    path.write_bytes(sub2.stdout)


def update_tokens(r):
    '''Takes a response dictionary, extracts tokens out of it, and updates token file.'''
    token['access_token'] = r['access_token']
    token['access_token_expiration'] = (datetime.now() +
                                        timedelta(seconds=int(r['expires_in']))).isoformat()
    if 'refresh_token' in r:
        token['refresh_token'] = r['refresh_token']
    writetokenfile()
    if verbose:
        print(f'New token, expires {token["access_token_expiration"]}.')


def renewToken():
    if not token['refresh_token']:
        sys.exit('ERROR: No refresh token. Run script with "--authorize".')
    registration = registrations[token['registration']]
    baseparams = {'client_id': registration['client_id']}
    # Microsoft uses 'tenant' but Google does not
    if 'tenant' in registration:
        baseparams['tenant'] = registration['tenant']
    p = baseparams.copy()
    p.update({'client_secret': registration['client_secret'],
              'refresh_token': token['refresh_token'],
              'grant_type': 'refresh_token'})
    try:
        response = urllib.request.urlopen(registration['token_endpoint'],
                                          urllib.parse.urlencode(p).encode())
    except urllib.error.HTTPError as err:
        print(err.code, err.reason)
        response = err
    response = response.read()
    response = json.loads(response)
    if 'error' in response:
        print(response['error'])
        if 'error_description' in response:
            print(response['error_description'])
        print('Perhaps refresh token invalid. Try running once with "--authorize"')
        sys.exit(1)
    update_tokens(response)


while int(subprocess.check_output('pgrep -fl imap.py | wc -l', shell=True).decode('utf-8')) == 0:
    # if process already running - drop out
    token = getToken()
    if access_token_valid(token):
        start = datetime.now()
        if verbose:
            print(f"Syncing at {start} ...")
        try:
            r = subprocess.run(f"offlineimap -c ~/.config/offlineimap/rc > {logfile} 2>&1", timeout=190, shell=True)
        except subprocess.TimeoutExpired as e:
            if verbose:
                print(f"Timeout at {datetime.now()}")
            os.system("pkill -fl offlineimap && pkill -fl offlineimap && pkill -fl offlineimap")
        end = datetime.now()
        if verbose:
            print(f"Done in {int((end-start).total_seconds())}s. Waiting {refresh}s ... ")
        time.sleep(refresh)
    else:
        if verbose:
            print("\nNeed new tokens ... \n")
        renewToken()

print("Already running - dropping out")

#!/usr/bin/env python3
"""
Documentation
https://developer.spotify.com/documentation/web-api/

APIs
https://developer.spotify.com/console/

Spotipy
https://spotipy.readthedocs.io/en/2.19.0/

Vim
~/.config/nvim/after/ftplugin/spot.vim
"""

import requests
import json
from base64 import b64encode

import spotipy
from spotipy.oauth2 import SpotifyOAuth   # credentials in zshrc

scope = "user-library-read \
          user-top-read \
          user-follow-read \
          user-read-playback-state \
          user-modify-playback-state \
          playlist-read-private \
          "
sp = spotipy.Spotify(auth_manager=SpotifyOAuth(scope=scope))
# sp = spotipy.Spotify(auth_manager=SpotifyOAuth(scope=scope,cache_path='/Users/pg/.config/python'))

def goHiFiPi():
    tid = sp.current_user_playing_track()["item"]["id"]
    devs = sp.devices()
    for dev in devs['devices']:
        if dev['name'] == 'HiFiPi':
            device_id = dev['id']
            sp.start_playback(uris=[f"spotify:track:{tid}"], device_id=device_id,)

def jprint(j):
    print(json.dumps(j, indent=4, sort_keys=True))

def search(q):
    q = q.strip()
    f = open(f"/Users/pg/Music/spotiphil/search.spot", "w")
    f.write(f"Search result for:\n '{q}'\n\n")
    f.write("Artists\n")
    for artist in sp.search(q,type='artist',limit=3)['artists']['items']:
        f.write(f"  {artist['name']:150}  {artist['id']}\n")
    f.write("\nSongs\n")
    for track in sp.search(q,type='track',limit=20)['tracks']['items']:
        f.write(f"  {track['name']:30}  {track['artists'][0]['name']:120}  {track['id']}\n")
    f.close()

# search('Wir sind helden')

def updatePlaylists():
    f = open("/Users/pg/Music/spotiphil/playlists.spot", "w")
    for playlist in sp.current_user_playlists()['items']:
        print(playlist['name'])
        f.write(f"{playlist['name']}\n")
        tracks = sp.playlist_items(playlist['id'])['items']
        for track in tracks:
            trackId = track['track']['id']
            name    = track['track']['name']
            album   = track['track']['album']['name']
            artist  = track['track']['artists'][0]['name']
            line = (f"  {name:50}  {artist:50}  {album:100}  {trackId}\n")
            print(line)
            f.write(line)
    f.close()

def updateAlbums():
    f = open("/Users/pg/Music/spotiphil/albums.spot", "w")
    limit = 50
    i = 50
    artistId = None
    while i == limit:
        i = 0
        for artist in sp.current_user_followed_artists(limit=limit,after=artistId)['artists']['items']:
            i += 1
            print(i,artist['name'])
            artistId = artist['id']
            f.write(f"{artist['name']}\n")
            try:
                for album in sp.artist_albums(artist['id'])['items']:
                    f.write(f"  {album['name']}\n")
                    for track in sp.album_tracks(album['id'])['items']:
                        f.write(f"    {track['name']:150}  {track['id']}\n")
            except:
                print('failed')
    f.close()

def recommendations():
    url = (f"{api}recommendations")
    return requests.get(url, headers=headers).json()


def play(tracks):
    device_id=sp.current_playback()['device']['id']
    devs = sp.devices()
    for dev in devs['devices']:
        if dev['name'] == 'HiFiPi':
            device_id = dev['id']
    uris = []
    tracks = tracks.split(' ')
    for track in tracks:
        if track:
            try:
                artistTracks = sp.artist_top_tracks(track, country='GB')
                for atrack in artistTracks['tracks']:
                    uris.append(f"spotify:track:{atrack['id']}")
            except:
                uris.append(f"spotify:track:{track}")
    sp.start_playback(uris=uris, device_id=device_id,)

def playing(showID=True):
    track = sp.current_user_playing_track()["item"]
    artist = track["artists"][0]["name"]
    name   = track["name"]
    trackId = track["id"]
    if showID:
        print (f"  {name:50}  {artist:150}  {trackId}\n")
    else:
        print (name)

def stepIn():
    """ skip to 1min in track """
    sp.seek_track(60000)

def next():
    sp.next_track()

def pause():
    sp.pause_playback()

def toggle():
    playback = sp.current_playback()
    if playback:
        if 'is_playing' in playback:
            if playback['is_playing']:
                sp.pause_playback()
            else:
                device_id=sp.current_playback()['device']['id']
                sp.start_playback(device_id=device_id)
    else:
        print('Start Spotify first')

def volume(vol):
    now_vol = sp.current_playback()['device']['volume_percent']
    if vol == '+':
        vol = now_vol + 5
    elif vol == '-':
        vol = now_vol - 5
    print(f"Volume: {vol}%")
    return sp.volume(vol)

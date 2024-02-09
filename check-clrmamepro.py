#!/usr/bin/python

import os, requests
import configparser

def get_version():
    homepage = requests.get("https://mamedev.emulab.it/clrmamepro/version", timeout=20)
    parser = configparser.ConfigParser()
    parser.read_string(homepage.text)
    return parser['clrmamepro']['version']

env_file = os.getenv('GITHUB_ENV')
with open(env_file, "a") as env:
    env.write(f"LATEST_VERSION={get_version()}\n")
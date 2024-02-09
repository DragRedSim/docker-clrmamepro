#!/usr/bin/python

import os, requests
import configparser

def get_version():
    homepage = requests.get("https://mamedev.emulab.it/clrmamepro/version", timeout=20)
    parser = configparser.ConfigParser()
    parser.read_string(homepage.text)
    return parser['clrmamepro']['version']

version = get_version()
with open(os.environ['GITHUB_OUTPUT'], "a") as env:
    print(f"LATEST_VERSION={version}\n", file=env)

print(f"Latest version: {version}")
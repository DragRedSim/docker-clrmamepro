import os, requests
import configparser

def get_version():
    homepage = requests.get("https://mamedev.emulab.it/clrmamepro/version", timeout=20)
    parser = configparser.ConfigParser()
    parser.read_string(homepage.text)
    return parser['clrmamepro']['version']

with open(os.environ['GITHUB_OUTPUT'], "a") as env:
    print(f"LATEST_VERSION={get_version()}\n", file=env)
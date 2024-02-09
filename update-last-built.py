#!/usr/bin/python

import os
from github import Auth, Github

token = os.getenv('GITHUB_TOKEN')

auth = Auth.Token(token)
g = Github(auth=auth)
g.get_user().login
r = g.get_repo(os.getenv("GITHUB_REPOSITORY"))
v = r.get_variable("LATEST_BUILT_VERSION")
v.edit(os.getenv("LATEST_VERSION"))
v.update()

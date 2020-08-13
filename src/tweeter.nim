import asyncdispatch

import jester

import db, view/[user, general]

routes:
  get "/":
    resp renderMain(renderLogin())

runForever()

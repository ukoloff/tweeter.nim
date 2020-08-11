import asyncdispatch

import jester

routes:
  get "/":
    resp "Hello, world!"

runForever()

import asyncdispatch, times
import jester

import view/[user, general], db

let dbh = newDB()

routes:
  get "/":
    if request.cookies.hasKey("username"):
      var user: User
      if not dbh.findUser(request.cookies["username"], user):
        user = User(name: request.cookies["username"], following: @[])
        dbh.create(user)
      let messages = dbh.findMessages(user.following & user.name)
      resp renderMain(renderTimeline(user.name, messages))
    else:
      resp renderMain(renderLogin())

  post "/login":
    setCookie("username", @"username", daysForward(1))
    redirect("/")

  post "/createMessage":
    let message = Message(
      user: @"username",
      time: getTime(),
      msg: @"message"
    )
    dbh.post(message)
    redirect("/")

runForever()

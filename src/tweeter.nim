import asyncdispatch, times
import jester

import view/[user, general], db

let dbh = newDB()

proc userLogin(db: DBase, request: Request, user: var User): bool =
  if request.cookies.hasKey("username"):
    if not db.findUser(request.cookies["username"], user):
      user = User(name: request.cookies["username"], following: @[])
      db.create(user)
    return true
  else:
    return false

routes:
  get "/":
    var user: User
    if dbh.userLogin(request, user):
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

  post "/follow":
    var follower: User
    var target: User
    if not dbh.findUser(@"follower", follower):
      halt "Follower not found"
    if not dbh.findUser(@"target", target):
      halt "Follow target not found"
    dbh.follow(follower, target)
    redirect(uri("/" & @"target"))

  get "/\\@@name":
    var user: User
    if not dbh.findUser(@"name", user):
      halt "User not found"
    let messages = dbh.findMessages(@[user.name])

    var me: User
    if dbh.userLogin(request, me):
      resp renderMain(renderUser(user, me) & renderMessages(messages))
    else:
      resp renderMain(renderUser(user) & renderMessages(messages))


runForever()

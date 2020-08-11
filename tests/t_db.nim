import os, times, unittest

import db as oops

test "DB":
  removeFile("db/tweeter_test.db")
  var db = newDB("tweeter_test.db")
  db.setup
  db.create(User(name: "d0m96"))
  db.create(User(name: "nim_lang"))
  db.post(Message(user: "nim_lang", time: getTime() - 4.seconds,
    msg: "Hello Nim in Action readers"))
  db.post(Message(user: "nim_lang", time: getTime(),
    msg: "99.9% off Nim in Action for everyone, for the next minute only!"))

  var dom: User
  doAssert db.findUser("d0m96", dom)
  var nim: User
  doAssert db.findUser("nim_lang", nim)
  db.follow(dom, nim)
  doAssert db.findUser("d0m96", dom)

  let messages = db.findMessages(dom.following)
  echo(messages)
  doAssert(messages[0].msg == "99.9% off Nim in Action for everyone, for the next minute only!")
  doAssert(messages[1].msg == "Hello Nim in Action readers")

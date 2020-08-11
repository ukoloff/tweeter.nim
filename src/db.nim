import times, db_sqlite, strutils

type
  User* = object
    name*: string
    following*: seq[string]

  Message* = object
    user*: string
    time*: Time
    msg*: string

type
  DBase* = ref object
    db: DbConn

proc newDB*(filename = "tweeter.db"): DBase =
  new result
  result.db = open("db/" & filename, "", "", "")

proc close*(db: DBase) =
  db.db.close()

proc setup*(db: DBase) =
  db.db.exec(sql"""
    Create Table If Not Exists User(
      name Text Primary Key
    )
    """)

  db.db.exec(sql"""
    Create Table If Not Exists Following(
      follower Text,
      user Text,
      Primary Key(follower, user)
      Foreign Key(follower) References User(name),
      Foreign Key(user) References User(name)
    )
    """)

  db.db.exec(sql"""
    Create Table If Not Exists Message(
      user Text,
      time Integer,
      msg Text Not Null,
      Foreign Key(user) References User(name)
    )
    """)


proc post*(db: DBase, msg: Message) =
  if msg.msg.len > 140:
    raise newException(ValueError, "Message has to be less than 140 characters")

  db.db.exec(sql"""
    Insert Into Message Values(?, ?, ?)
  """, msg.user, $msg.time.toUnix(), msg.msg)

proc follow*(db: DBase, follower, user: User) =
  db.db.exec(sql"""
    Insert Into Following values(?, ?)
  """, follower.name, user.name)

proc create*(db: DBase, user: User) =
  db.db.exec(sql"""
    Insert Into User values(?)
  """, user.name)

proc findUser*(db: DBase, name: string, user: var User): bool =
  let row = db.db.getRow(sql"""
    Select name from User
    Where name = ?
  """, name)
  if row[0].len == 0:
    return false
  else:
    user.name = row[0]

  let following = db.db.getAllRows(sql"""
    Select user From Following
    Where follower = ?
  """, user.name)
  user.following = @[]
  for row in following:
    if row[0].len != 0:
      user.following.add(row[0])
  return true

proc findMessages*(db: DBase, users: seq[string], limit = 10): seq[Message] =
  result = @[]
  var whereClause = ""
  for u in users:
    if whereClause.len > 0:
      whereClause &= " Or "
    whereClause &= "user = ?"
  if whereClause.len == 0:
    return
  let msgz = db.db.getAllRows(sql("""
    Select user, time, msg
    From Message
    Where
  """ & whereClause & """
    Order By time Desc
    Limit """ & $limit), users)
  for row in msgz:
    result.add(Message(
      user: row[0],
      time: row[1].parseInt.fromUnix,
      msg: row[2]
    ))

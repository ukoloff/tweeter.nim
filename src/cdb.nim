import db_sqlite

var db = open("tweeter.db", "", "", "")

db.exec(sql"""
  Create Table If Not Exists User(
    name Text Primary Key
  )
  """)

db.exec(sql"""
  Create Table If Not Exists Following(
    follower Text,
    user Text,
    Primary Key(follower, user)
    Foreign Key(follower) References User(name),
    Foreign Key(user) References User(name)
  )
  """)

db.exec(sql"""
  Create Table If Not Exists Message(
    user Text,
    time Integer,
    msg Text Not Null,
    Foreign Key(user) References User(name)
  )
  """)

db.close()

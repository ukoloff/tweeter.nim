import times

type
  User* = object
    name*: string
    following*: seq[string]

  Message* = object
    user*: string
    time*: Time
    msg*: string

#? stdtmpl(subsChar = '$', metaChar = '#', toString = "xmltree.escape")
#import ../db
#import xmltree
#import times
#
#proc renderUser*(user: User): string =
# result = ""
<div id="user">
  <h1>${user.name}</h1>
  <span>Following: ${$user.following.len}</span>
</div>
#end proc
#
#proc renderUser*(user, me: User): string =
#  result = ""
<div id="user">
  <h1>${user.name}</h1>
  <span>Following: ${$user.following.len}</span>
  #if user.name notin me.following:
    <form action="follow" method="post">
      <input type="hidden" name="follower" value="${me.name}">
      <input type="hidden" name="target" value="${user.name}">
      <input type="submit" value="Follow">
    </form>
  #end if
</div>
#end proc
#
#proc renderMessages*(messages: seq[Message]): string =
#  result = ""
<div id="messages">
#for message in messages:
  <div>
    <a href="/@${message.user}">${message.user}</a>
    <span>${message.time.getGMTime().format("HH:mm MMMM d',' yyyy")}</span>
    <h3>${message.msg}</h3>
  </div>
#end for
</div>
#end proc
#
#when isMainModule:
#  echo renderUser(User(name: "d0m96<>", following: @[]))
# echo renderMessages(@[
#   Message(user: "d0m96", time: getTime(), msg: "Hello World!"),
#   Message(user: "d0m96", time: getTime(), msg: "Testing")
# ])
#end when

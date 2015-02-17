# Description
#   Post gitbucket related events using gitbucket hooks
#
# Configuration:
#   None
#
# Commands:
#   None 
#
# Author:
#   masatof

codec = (data) ->
  tmp = data.split('"')
  tmp[tmp.length-2]

codec_default_webhook = (datalist) ->
    pusher = "@" + codec(datalist[0])
    ref = codec(datalist[2]).split('/')[2]
    message = codec(datalist[4])
    repository = codec(datalist[12])

    if datalist.length == 20
      repository = codec(datalist[12])
    else
      repository = codec(datalist[21])

    "#{pusher} pushed to #{ref} at #{repository}:\n\n#{message}"

module.exports = (robot) ->
  robot.router.post "/gitbucket-webhook", (req, res) ->
    users = ['fukuyama']

    hook = req.body
    datalist = hook.payload.split(",")

    console.log datalist

    if datalist.length >= 20
      robot.send "Lobby", codec_default_webhook(datalist)
    else
      owner = codec(datalist[0])
      name = codec(datalist[1])
      issueId = datalist[2].split(':')[1].split(',')[0]
      content = codec(datalist[3])
      msg = "#{name} ##{issueId} @#{owner}\n\n#{content}"
      robot.send "Lobby", msg
      for user in users
        if content.indexOf(user) isnt -1
          robot.send {room: "#" + user}, msg

    res.end ''


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

module.exports = (robot) ->
	robot.router.post "/gitbucket-webhook", (req, res) ->
		hook = req.body
		datalist = hook.payload.split(",")

		console.log datalist

		pusher = "@" + codec(datalist[0])
		ref = codec(datalist[2])
		message = codec(datalist[4])
		repository = codec(datalist[12])

		if datalist.length == 20
			repository = codec(datalist[12])
		else
			repository = codec(datalist[21])

		msg = "#{pusher} pushed to #{ref} at #{repository}:\n\n#{message}"

		robot.send "Lobby", msg
		res.end ''

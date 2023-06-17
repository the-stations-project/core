{ WRITE } = require 'coffee-standards'

# GLOBAL
sessions = new Map()

# MAIN
CHECK_SES = (ip, uname) ->
	match = sessions.get ip
	if match
		match.username == uname
	else
		false

TRACK_SES = (ip, uname, ws) ->
	val =
		username: uname
		ws: ws
	sessions.set ip, val

UNTRACK_SES = (ip) ->
	sessions.delete ip

LIST_SES = (uname) ->
	[...sessions.entries()]
		.filter((entry) ->
			entry[1].username == uname)

LIST_SES_IP = (uname) ->
	res = LIST_SES uname
		.map ((x) -> x[0])

	WRITE res
	return res

# EXPORT
module.exports =
	CHECK_SES: CHECK_SES,
	TRACK_SES: TRACK_SES,
	UNTRACK_SES: UNTRACK_SES,
	LIST_SES: LIST_SES,
	LIST_SES_IP: LIST_SES_IP,

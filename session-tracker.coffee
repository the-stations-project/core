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
	match = sessions.get(ip)
	WRITE match
	if match and match.username == uname
		TRACK_WS ip, ws
		return

	val =
		username: uname
		ws: [ws]
	sessions.set ip, val

TRACK_WS = (ip, ws) ->
	match = sessions.get(ip)
	unless match
		return

	unless ws in match.ws
		match.ws.push ws

UNTRACK_SES = (ip) ->
	sessions.delete ip

UNTRACK_WS = (ip, ws) ->
	match = sessions.get(ip)
	unless match
		return

	index = match.ws.indexOf(ws)
	if index == -1
		return

	# remove ws
	match.ws.splice(index, 1)

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
	CHECK_SES: CHECK_SES
	TRACK_SES: TRACK_SES
	TRACK_WS: TRACK_WS
	UNTRACK_SES: UNTRACK_SES
	UNTRACK_WS: UNTRACK_WS
	LIST_SES: LIST_SES
	LIST_SES_IP: LIST_SES_IP

{ WRITE } = require 'coffee-standards'

# GLOBAL
sessions = new Map()

# MAIN
CHECK_SES = (uname, ip) ->
	match = sessions.get ip
	if match
		match == uname
	else
		false

TRACK_SES = (uname, ip) ->
	sessions.set ip, uname

UNTRACK_SES = (uname, ip) ->
	sessions.delete ip, uname

LIST_SES = (uname) ->
	[...sessions.entries()]
		.filter((entry) ->
			entry[1] == uname)
		.map((entry) ->
			entry[0])
		.join ' '

# EXPORT
module.exports =
	CHECK_SES: CHECK_SES,
	TRACK_SES: TRACK_SES,
	UNTRACK_SES: UNTRACK_SES,
	LIST_SES: LIST_SES,

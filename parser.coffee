{ WRITE } = require 'coffee-standards'

module.exports = (msg, RPLY_TXT) ->
	id = '0'

	# SUPPORT
	RPLY = (rply) ->
		obj =
			id: id
			reply: rply
		txt = JSON.stringify obj
		RPLY_TXT txt
	
	ERROR = () ->
		RPLY 'error'

	# MAIN
	try
		obj = JSON.parse msg
		unless obj.header
			WRITE 'refusing to parse message without header'
			do ERROR
			return
		unless obj.id
			WRITE 'refusing to parse message without id'
			do ERROR
			return

		id = obj.id
		PARSE obj, RPLY, ERROR

	catch
		WRITE """
		failed to parse message:
		#{msg}
		"""

		do ERROR

	RPLY 'end'

PARSE = (obj, RPLY, ERROR) ->
	switch obj.header
		when 'test'
			RPLY 'ok'
		else
			WRITE 'message header invalid'
			do ERROR

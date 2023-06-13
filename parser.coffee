{ WRITE } = require 'coffee-standards'

EXEC = require './child-process-manager.js'
{ INIT_USR } = require './user-manager.js'

module.exports = (msg, config, REPLY_TXT) ->
	id = '0'

	# SUPPORT
	REPLY = (reply) ->
		obj =
			id: id
			reply: reply
		txt = JSON.stringify obj
		REPLY_TXT txt
	
	ERROR = () ->
		REPLY 'error'

	# MAIN
	try
		obj = JSON.parse msg
		unless obj.header or obj.id
			do ERROR
			return

		id = obj.id
		try
			await PARSE obj, config, REPLY, ERROR
		catch
			WRITE "crashed running #{msg}"
			do ERROR

	catch
		WRITE "error parsing #{msg}"
		do ERROR

	REPLY 'end'

PARSE = (obj, config, REPLY, ERROR) ->
	new Promise (EXIT) ->
		WRITE obj.header

		switch obj.header
			when 'test'
				REPLY 'ok'
				do EXIT
			when 'exec'
				EXEC obj.username, obj.command, config.basePath, REPLY, ERROR, EXIT
			when 'init'
				try
					INIT_USR config.basePath, obj.username
				catch
					do ERROR
					do EXIT
			else
				WRITE 'message header invalid'
				do ERROR
				do EXIT

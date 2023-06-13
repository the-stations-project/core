{ WRITE } = require 'coffee-standards'

EXEC = require './child-process-manager.js'
{ USERADD, USERDEL } = require './user-manager.js'

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
		switch obj.header
			when 'test'
				REPLY 'ok'
				do EXIT
			when 'exec'
				EXEC obj.username, obj.command, config.basePath, REPLY, ERROR, EXIT
			when 'create-account'
				try
					USERADD config.basePath, obj.username
				catch
					do ERROR
					do EXIT
			when 'close-account'
				try
					USERDEL config.basePath, obj.username
				catch
					do ERROR
					do EXIT
			else
				do ERROR
				do EXIT

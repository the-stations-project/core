{ WRITE } = require 'coffee-standards'

EXEC = require './child-process-manager.js'
{ USERADD, USERDEL } = require './user-manager.js'
{ AUTH, FORCE_SET_PASSWD, SET_PASSWD } = require './security.js'

module.exports = (msg, config, _DIRS, REPLY_TXT) ->
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
			await PARSE obj, config, _DIRS, REPLY, ERROR
		catch error
			WRITE "crashed running #{msg}"
			WRITE error
			WRITE '###\n'
			do ERROR

	catch
		WRITE "error parsing #{msg}"
		do ERROR

	REPLY 'end'

PARSE = (obj, config, _DIRS, REPLY, ERROR) ->
	new Promise (EXIT) ->
		switch obj.header
			when 'test'
				REPLY 'ok'
				do EXIT
			when 'exec'
				EXEC obj.username, obj.command, config.basePath, REPLY, ERROR, EXIT
			when 'create-account'
				unless config.allowRegistration == true
					do ERROR
					do EXIT
					return

				USERADD config.basePath, obj.username
			when 'close-account'
				USERDEL config.basePath, obj.username
			when 'signin'
				REPLY AUTH obj.username, obj.password, _DIRS.pswd
			when 'passwd'
				SET_PASSWD obj.username, obj.password, _DIRS.pswd
			when 'passwd!'
				FORCE_SET_PASSWD obj.username, obj.password, _DIRS.pswd
			else
				do ERROR
				do EXIT

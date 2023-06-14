{ WRITE } = require 'coffee-standards'

EXEC = require './child-process-manager.js'
{ USERADD, USERDEL } = require './user-manager.js'
{ AUTH, FORCE_SET_PASSWD, SET_PASSWD } = require './security.js'
{ CHECK_SES, LIST_SES, TRACK_SES, UNTRACK_SES } = require './session-tracker.js'

module.exports = (msg, config, ip, _DIRS, REPLY_TXT) ->
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
			await PARSE obj, config, ip, _DIRS, REPLY, ERROR
		catch error
			WRITE "crashed running #{msg}"
			WRITE error
			WRITE '###\n'
			do ERROR

	catch
		WRITE "error parsing #{msg}"
		do ERROR

	REPLY 'end'

PARSE = (obj, config, ip, _DIRS, REPLY, ERROR) ->
	new Promise (EXIT) ->
		GUARD = () ->
			unless CHECK_SES obj.username, ip
				do ERROR
				do EXIT

		switch obj.header
			# basic
			when 'test'
				REPLY 'ok'
				do EXIT

			# exec
			when 'exec'
				do GUARD
				WRITE 'test'
				EXEC obj.username, obj.command, config.basePath, REPLY, ERROR, EXIT

			# account
			when 'create-account'
				unless config.allowRegistration == true
					do ERROR
					do EXIT
					return

				USERADD config.basePath, obj.username
			when 'close-account'
				do GUARD
				USERDEL config.basePath, obj.username, _DIRS.pswd
			when 'passwd'
				do GUARD
				SET_PASSWD obj.username, obj.password, _DIRS.pswd
			when 'passwd!'
				do GUARD
				FORCE_SET_PASSWD obj.username, obj.password, _DIRS.pswd

			# sessions
			when 'sign-in'
				result = AUTH obj.username, obj.password, _DIRS.pswd
				if result == true
					TRACK_SES obj.username, ip
				REPLY result
			when 'get-sessions'
				do GUARD
				REPLY LIST_SES obj.username
			when 'sign-out'
				do GUARD
				UNTRACK_SES obj.username, ip
			
			else
				do ERROR
				do EXIT

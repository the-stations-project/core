{ WRITE } = require 'coffee-standards'

EXEC = require './child-process-manager.js'
{ USERADD, USERDEL } = require './user-manager.js'
{ AUTH, SET_PASSWD } = require './security.js'
{ CHECK_SES, LIST_SES, LIST_SES_IP, TRACK_SES, UNTRACK_SES } = require './session-tracker.js'

module.exports = (msg, config, ip, ws, _DIRS, REPLY_TXT) ->
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
			await PARSE obj, config, ip, ws, _DIRS, REPLY, ERROR
		catch error
			WRITE "crashed running #{msg}"
			WRITE error
			WRITE '###\n'
			do ERROR

	catch
		WRITE "error parsing #{msg}"
		do ERROR

	REPLY 'end'

PARSE = (obj, config, ip, ws, _DIRS, REPLY, ERROR) ->
	new Promise (RESOLVE) ->
		FORCE_EXIT = () ->
			do ERROR
			do RESOLVE
			throw 'forced exit'

		GUARD = (...args) ->
			undefinedIndex = args.indexOf undefined
			unless undefinedIndex == -1
				do FORCE_EXIT

		REQUIRE_TRACKING = () ->
			unless CHECK_SES ip, obj.username
				do FORCE_EXIT

		REQUIRE_AUTH = () ->
			GUARD obj.username, obj.password
			auth = AUTH obj.username, obj.password, _DIRS.pswd
			unless auth == true
				do FORCE_EXIT

		switch obj.header
			# basic
			when 'test'
				REPLY 'ok'
				do RESOLVE

			# account
			when 'create-account'
				unless config.allowRegistration == true
					do FORCE_EXIT
				GUARD obj.username

				USERADD config.basePath, obj.username
				REPLY 'ok'
			when 'close-account'
				do REQUIRE_TRACKING
				do REQUIRE_AUTH
				GUARD obj.username

				USERDEL config.basePath, obj.username, _DIRS.pswd
				REPLY 'ok'
			when 'passwd'
				do REQUIRE_TRACKING
				do REQUIRE_AUTH
				GUARD obj.username, obj.password, obj.newPassword

				SET_PASSWD obj.username, obj.newPassword, _DIRS.pswd
				REPLY 'ok'
			when 'passwd!'
				do REQUIRE_TRACKING
				do REQUIRE_AUTH
				GUARD obj.username, obj.targetUser, obj.newPassword
				adminIndex = config.administrators.indexOf obj.username
				if adminIndex == -1
					do FORCE_EXIT

				SET_PASSWD obj.targetUser, obj.newPassword, _DIRS.pswd
				REPLY 'ok'

			# exec
			when 'exec'
				do REQUIRE_TRACKING
				GUARD obj.username, obj.command

				EXEC obj.username, obj.command, config.basePath, REPLY, ERROR, RESOLVE

			# messaging
			when 'broadcast'
				do REQUIRE_TRACKING
				GUARD obj.channel, obj.targetUsers

				obj.id = undefined

				for user in obj.targetUsers
					sessions = LIST_SES user
					for session in sessions
						sockets = session[1].ws
						unless (Array.isArray sockets)
							do ERROR
							do FORCE_EXIT
						
						for ws in sockets
							ws.send JSON.stringify obj

				REPLY 'ok'

			# sessions
			when 'sign-in'
				GUARD obj.username, obj.password

				result = AUTH obj.username, obj.password, _DIRS.pswd
				if result == true
					TRACK_SES ip, obj.username, ws
				REPLY result
			when 'get-sessions'
				do REQUIRE_TRACKING
				GUARD obj.username

				REPLY LIST_SES_IP obj.username
			when 'sign-out'
				do REQUIRE_TRACKING
				UNTRACK_SES ip
				REPLY 'ok'
			
			else
				do ERROR
				do RESOLVE

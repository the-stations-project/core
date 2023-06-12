# IMPORTS
{ WRITE } = require 'coffee-standards'

PARSE = require './parser.js'

EXPRESS = require 'express'
HTTP = require 'http'
WS = require 'ws'

module.exports = (config, ifaceDir) ->
	# GLOBAL
	APP = EXPRESS()

	# SERVER
	route = EXPRESS.static ifaceDir
	APP.use route
	server = APP.listen config.port, () ->
		WRITE "server up on port #{config.port}"


	# COMMS
	_WSOPTS =
		server: server

	wsServer = new WS.Server _WSOPTS

	wsServer.on 'connection', (ws, req) ->
		WRITE "new connection from '#{req.socket.remoteAddress}'"

		ws.on 'message', (data) ->
			msg = do data.toString
			PARSE msg, (rply) ->
				ws.send rply

		ws.send 'welcome'

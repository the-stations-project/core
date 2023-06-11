# IMPORTS
{ WRITE } = require 'coffee-standards'
EXPRESS = require 'express'

module.exports = (config) ->
	# GLOBAL
	APP = EXPRESS()
	
	# MAIN
	APP.get '/', (req, res) ->
		res.send 'Hello, world!'
	
	APP.listen config.port, () ->
		WRITE 'server up'

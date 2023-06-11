# IMPORTS
{ WRITE } = require 'coffee-standards'
EXPRESS = require 'express'

module.exports = (config, ifaceDir) ->
	# GLOBAL
	APP = EXPRESS()
	dir = EXPRESS.static ifaceDir

	# MAIN
	APP.use dir

	APP.listen config.port, () ->
		WRITE 'server up'

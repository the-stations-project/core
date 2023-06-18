{ LSDIR, PJN, WRITE } = require 'coffee-standards'
FS = require 'fs'
CHPR = require 'child_process'

module.exports = (username, command, basePath, REPLY, ERROR, EXIT) ->
	_CFG =
		shell: true
		cwd: PJN basePath, username

	cp = CHPR.spawn "sudo -u #{username} #{command}", _CFG
	cp.on 'error', ERROR

	PARSE_OPT = (data) ->
		REPLY do data.toString

	cp.stdout.on 'data', PARSE_OPT
	cp.stderr.on 'data', PARSE_OPT

	cp.on 'close', EXIT

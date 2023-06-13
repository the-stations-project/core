{ EXEC, MKDIR, PJN, WRITE } = require 'coffee-standards'
CHPR = require 'child_process'

INIT = (basePath, username) ->
	userDir = PJN basePath, username
	privateDir = PJN userDir, 'private'
	publicDir = PJN userDir, 'public'
	dirNames = [ userDir, privateDir, publicDir ]

	for dir in dirNames
		WRITE dir
		MKDIR dir
		EXEC "chown #{username} #{dir}"

	EXEC "chmod 700 #{privateDir}"

module.exports =
	INIT_USR: INIT

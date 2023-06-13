{ EXEC, MKDIR, PJN, WRITE } = require 'coffee-standards'

INIT = (basePath, username) ->
	EXEC "id -u #{username}"

	userDir = PJN basePath, username
	privateDir = PJN userDir, 'private'
	publicDir = PJN userDir, 'public'
	dirNames = [ userDir, privateDir, publicDir ]

	for dir in dirNames
		MKDIR dir
		EXEC "chown #{username} #{dir}"

	EXEC "chmod 700 #{privateDir}"

module.exports =
	INIT_USR: INIT

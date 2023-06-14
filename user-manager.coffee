{ DEL, EXEC, FCHK, MKDIR, PJN, WRITE } = require 'coffee-standards'

# SUPPOORT
GET_PATHS = (basePath, username) ->
	userDir = PJN basePath, username
	privateDir = PJN userDir, 'private'
	publicDir = PJN userDir, 'public'
	[ userDir, privateDir, publicDir ]

# MAIN
USERADD = (basePath, username) ->
	EXEC "useradd #{username}"

	dirs = GET_PATHS basePath, username

	for dir in dirs
		MKDIR dir
		EXEC "chown #{username} #{dir}"

	EXEC "chmod 700 #{dirs[1]}"

USERDEL = (basePath, username, pswdDir) ->
	dirs = GET_PATHS basePath, username

	for dir in dirs
		if FCHK dir
			DEL dir

	DEL PJN pswdDir, username

	EXEC "userdel #{username}"

# EXPORT
module.exports =
	USERADD: USERADD,
	USERDEL: USERDEL

{ FOUT, MKDIR, WRITE } = require 'coffee-standards'
CHPR = require 'child_process'

INIT = (basePath, username) ->
	userDir = PJN basePath, username
	dirNames = [ userDir, (PJN userdir, 'private'), (PJN userdir, 'public') ]

	for dir in dirs
		MKDIR dir

	

module.exports =
	INIT_USR: INIT

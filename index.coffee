# IMPORTS
{ WRITE, FCHK, FIN, FOUT, MKDIR, PJN } = require 'coffee-standards'
INIT_SERVER = require './server.js'

# CONSTANTS
_DIR = 'data'
_CFG_PATH = PJN _DIR, 'config.json'

_FOPTS =
	encoding: 'utf8'

# GLOBAL
config =
	port: 8080
	allowRegistration: false

# MAIN
INIT = () ->
	unless FCHK _DIR
		MKDIR _DIR

	do READ_CFG

	INIT_SERVER config

READ_CFG = () ->
	if FCHK _CFG_PATH
		WRITE 'reading configuration file...'
		configString = FIN _CFG_PATH, _FOPTS
		try
			storedConfig = JSON.parse configString
			for entry in Object.entries storedConfig
				[key, val] = entry
				config[key] = val
			WRITE 'done'
		catch
			WRITE 'could not parse config file'
			do process.exit
	else
		WRITE 'creating configuration file...'
		configString = JSON.stringify config, null, 4
		FOUT _CFG_PATH, configString
		WRITE 'done'

#####
do INIT

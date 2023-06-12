# IMPORTS
{ WRITE, FCHK, FIN, FOUT, MKDIR, PJN } = require 'coffee-standards'
INIT_SERVER = require './server.js'

# CONSTANTS
_DIRS = ['data', 'data/interface']
_CFG_PATH = PJN _DIRS[0], 'config.json'

_FOPTS =
	encoding: 'utf8'

# GLOBAL
config =
	port: 8080
	allowRegistration: false
	basePath: '/home/frugal-cloud'

# MAIN
INIT = () ->
	for dir in _DIRS
		unless FCHK dir
			MKDIR dir

	do READ_CFG
	do REPAIR_BASE

	INIT_SERVER config, _DIRS[1]

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

REPAIR_BASE = () ->
	unless FCHK config.basePath
		try
			MKDIR config.basePath
		catch
			WRITE 'could not create base path. consider running with root access'

#####
do INIT

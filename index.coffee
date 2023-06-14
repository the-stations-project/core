# IMPORTS
{ WRITE, FCHK, FIN, FOUT, MKDIR, PJN } = require 'coffee-standards'

INTEGRITY_CHECK = require './integrity-control.js'
INIT_SERVER = require './server.js'

# CONSTANTS
_DIRS =
	'data': 'data',
	'iface': 'data/interface'
	'pswd': 'data/pswd-hashes'
_CFG_PATH = PJN _DIRS.data, 'config.json'

_FOPTS =
	encoding: 'utf8'

# GLOBAL
config =
	port: 8080
	allowRegistration: false
	basePath: '/home'

# MAIN
INIT = () ->
	for dir in Object.values _DIRS
		unless FCHK dir
			MKDIR dir

	do READ_CFG
	do INTEGRITY_CHECK
	do REPAIR_BASE

	INIT_SERVER config, _DIRS

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
			WRITE 'WRITE could not parse config file'
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
			WRITE 'ERROR could not create base path. consider running with root access'
			do process.exit

#####
do INIT

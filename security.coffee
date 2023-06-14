{ FCHK, FIN, FOUT, PJN, WRITE } = require 'coffee-standards'
CRYPTO = require 'crypto'

# SUPPORT
HASH = (input) ->
	CRYPTO.createHash 'md5'
		.update input
		.digest 'hex'

# MAIN
AUTH = (username, passwd, dir) ->
	path = PJN dir, username
	unless FCHK path
		false
	
	correctHash = FIN path
	givenHash = HASH passwd
	givenHash == correctHash

SET_PASSWD = (username, passwd, dir, ERROR) ->
	unless AUTH username, passwd
		do ERROR

	FORCE_SET_PASSWD username, passwd, dir

FORCE_SET_PASSWD = (username, passwd, dir) ->
	path = PJN dir, username
	hashed = HASH passwd
	FOUT path, hashed

# EXPORT
module.exports =
	AUTH: AUTH,
	SET_PASSWD: SET_PASSWD,
	FORCE_SET_PASSWD: FORCE_SET_PASSWD,

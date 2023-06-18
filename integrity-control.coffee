{ WRITE, EXEC } = require 'coffee-standards'

module.exports = () ->
	to_check = [
		'chmod',
		'chown',
		'su',
	]

	for cmd in to_check
		try
			EXEC "which #{cmd}"
		catch
			WRITE "ERROR '#{cmd} not found"
			do process.exit

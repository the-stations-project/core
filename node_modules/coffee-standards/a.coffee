# _CONSTATNS
_DIR_OPTS =
	recursive: true

_FILE_OPTS =
	encoding: 'utf8'

_IFCE_OPTS =
	input: process.stdin
	output: process.stdout

# _IMPORTS
CHPR = require 'child_process'
FS = require 'fs'
PTH = require 'path'
RL = require 'readline/promises'

# BASIC
PJN = (...parts) ->
	PTH.join ...parts.map STR

READ = (qry) ->
	iface = RL.createInterface _IFCE_OPTS
	resp = await iface.question qry
	do iface.close

	resp

STR = (x) ->
	do x.toString

WRITE = (...items) ->
	console.log ...items

# CHILD PROCESS
EXEC = (cmd) ->
	CHPR.execSync cmd


# FS
CP = (src, dst) ->
	FS.cpSync src, dst, _DIR_OPTS

FCHK = (pth) ->
	FS.existsSync pth

FIN = (pth) ->
	FS.readFileSync pth, _FILE_OPTS

FOUT = (pth, cnt) ->
	FS.writeFileSync pth, cnt, _FILE_OPTS

LSDIR = (pth) ->
	FS.readdirSync pth

MKDIR = (pth) ->
	FS.mkdirSync pth, _DIR_OPTS

DEL = (pth) ->
	FS.rmSync pth, _DIR_OPTS

# _EXPORT
module.exports = {
	PJN, READ, STR, WRITE,
	EXEC,
	CP, FCHK, FIN, FOUT, LSDIR, MKDIR, DEL
}

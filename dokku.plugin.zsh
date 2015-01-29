#!/bin/zsh

DOKKU_HOST=app.9k1.us
typeset -Ag DOKKU_COMMANDS

function dokku {
	emulate -L zsh
	local app gitremote
	local cmd=${1:-help}
	local remote=dokku@$DOKKU_HOST
	local init=0
	local host=$DOKKU_HOST

	if [[ ! -z $1 ]]; then
		shift
	fi

	if git status 2>/dev/null >/dev/null; then
		gitremote=$(git remote -v | grep -Po 'dokku@[a-zA-Z0-9:.-]+' | head -n 1)

		if [[ ! -z $gitremote ]]; then
			app=${gitremote##*:}
			remote=${gitremote%:*}
			host=${remote##*@}
			init=1
		else
			app=$(basename $(git rev-parse --show-toplevel))
		fi
	fi

	if [[ -z $DOKKU_COMMANDS[$host] ]]; then
		_dokku-reload-commands
	fi

	if [[ $cmd == 'init' ]]; then
		if [[ $init = 0 ]]; then
			-dokku-init $remote
		else
			print 'Dokku remote exists.'
		fi
	elif [[ $init == 1 && ! -z $app && ! -z $cmd && ! -z ${${DOKKU_COMMANDS[$host]}[(r)$cmd]} ]]; then
		_dokku-ssh $cmd $app $@
	else
		_dokku-ssh $cmd $@
	fi
}

function _dokku-ssh {
	ssh -t $remote $@
}

function _dokku-reload-commands {
	DOKKU_COMMANDS[$host]=$(_dokku-ssh | tail -n +3 | grep -Po '[^ ]+(?= <app>)')
}

function -dokku-init {
	git remote add dokku $remote:$app
}

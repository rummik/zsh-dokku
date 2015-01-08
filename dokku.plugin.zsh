#!/bin/zsh

DOKKU_HOST=app.9k1.us

function dokku {
	emulate -L zsh
	local app
	local cmd=$1
	local remote
	local init

	if [[ ! -z $cmd ]]; then
		shift
	fi

	if git status 2>/dev/null >/dev/null; then
		remote=$(git remote -v | grep -Po 'dokku@[a-zA-Z0-9:.-]+' | head -n 1)

		if [[ ! -z $remote ]]; then
			app=${remote##*:}
			remote=${remote%:*}
			init=0
		else
			app=$(basename $(git rev-parse --show-toplevel))
			remote=dokku@$DOKKU_HOST
			init=1
		fi
	fi

	if [[ $cmd == 'init' ]]; then
		if [[ $init = 1 ]]; then
			-dokku-init $remote
		else
			print 'Dokku remote exists.'
		fi
	elif [[ ! -z $cmd && ! -z $(_dokku-ssh help | grep -Po "$cmd <app>") ]]; then
		_dokku-ssh $cmd $app $@
	else
		_dokku-ssh $cmd $@
	fi
}

function _dokku-ssh {
	ssh -t $remote $@
}

function -dokku-init {
	git remote add dokku $remote:$app
}
#! /bin/zsh

FAVPATH=~/.favorites

function go(){
	local a=`grep "^$1:" $FAVPATH`
	if [ $a ]; then
		a=("${(s/:/)a}")
		cd $a[2]
		return 0
	else
		return 1
	fi
}

function favadd(){
	if [ `echo $1 | grep '[^a-zA-Z0-9_]'` ]; then
		echo "favadd: $1 is an illegal fav" 1>&2
		return 1
	fi
	if [ `cut -d : -f 1 $FAVPATH | grep $1` ]; then
		echo "favadd: $1 already exists" 1>&2
		return 1
	fi
	echo "$1:$(pwd)" >> "$FAVPATH"
}

function favrm(){
	sed -i -r "/^$1:/d" $FAVPATH
}

function favbu(){
	if [ $1 ]; then
		cp $FAVPATH $1
	else
		cp $FAVPATH ~/favorites_bu
	fi
}

function favrestore(){
	cp -f $1 $FAVPATH
}

alias favlist='sort $FAVPATH | sed "s/:/:-- /g" | column -t -s :'

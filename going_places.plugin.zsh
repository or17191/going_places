#! /bin/zsh

FAVPATH=~/.favorites

function _get_favloc(){
	local a=`grep "^$1:" $FAVPATH`
	if [ $a ]; then
		a=("${(s/:/)a}")
		local dst="$a[2]"
        if [ $2 ]; then
            dst="${dst}/$2"
        fi
        if [ -d $dst ]; then
            echo "$dst"
            return 0
        else
            return 1
        fi
	else
		return 1
	fi
}

function go(){
    local loc="$(_get_favloc $@)"
    if [ $loc ]; then
        cd "$loc"
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
	local args=$(for i do echo -n "|$i"; done)
	args=$args[2,-1]
	sed -i -r "/^$args:/d" $FAVPATH
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


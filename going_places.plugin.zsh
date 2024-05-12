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

function goto(){
    local loc="$(_get_favloc $@)"
    if [ $loc ]; then
        cd "$loc"
        return 0
    else
        return 1
    fi
}

function favadd(){
    local fav_name="${1:-$(basename "$PWD")}"

    # Check for illegal characters in the favorite name
    if [[ "$fav_name" =~ [^a-zA-Z0-9_] ]]; then
        echo "favadd: $fav_name contains illegal characters" 1>&2
        return 1
    fi

    # Check if the favorite already exists
    if grep -q "^$fav_name:" "$FAVPATH"; then
        echo "favadd: $fav_name already exists" 1>&2
        return 1
    fi

    # Add the favorite
    echo "$fav_name:$(pwd)" >> "$FAVPATH"
    echo "favadd: $fav_name added to favorites" 1>&2
}

function favrm(){
    # Set default favorite name to current directory's base name if no argument is provided
    local fav_name="${1:-$(basename "$PWD")}"
    # Check if the favorite exists
    if grep -q "^$fav_name:" "$FAVPATH"; then
        # Remove the favorite
        sed -i -r "/^$fav_name:/d" $FAVPATH
        echo "favrm: $fav_name removed from favorites" 1>&2
    else
        # Print an error if the favorite does not exist
        echo "favrm: $fav_name does not exist on favorites list" 1>&2
        return 1
    fi
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

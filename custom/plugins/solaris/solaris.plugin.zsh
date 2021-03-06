# vim: set filetype=zsh :
#
# Fix compatability problems on OSS solaris servers.
export PATH='/usr/local/gnu/bin:/usr/local/bin:/usr/xpg4/bin:/usr/dt/bin:/usr/openwin/bin:/usr/ucb:/usr/bin:/opt/SUNWspro/bin:/usr/ccs/bin'

#return if not running interactively
[ -z "$PS1" ] && return 

#export statements
export TERM='xterm'

#aliases for ls
alias ls='/usr/local/gnu/bin/ls -hF --color=auto'
alias lsd="ls --color=always -alh"
alias lf="ls --color=always -lh"
alias l="ls"
alias s="l"
alias la="ls -Alh"
alias ll="ls -lh"

#rpm aliases
alias specs="cd ~/rpmbuild/SPECS"
alias src='cd ~/rpmbuild/SOURCES'
alias srpms='cd ~/rpmbuild/SRPMS'
alias rpms='cd ~/rpmbuild/RPMS'

function rpmsubmit () {
	if ! (($+1))
	then
		echo "Usage rpmsubmit packagename [repo]"
		return 2
	fi

	pushd ~/rpmbuild &> /dev/null
	vnum=`ls -lt SRPMS/$1-* | awk 'NR == 1 { print $NF }' | cut -d/ -f2- | egrep -o "[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*-[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*.src.rpm$" | sed "s/.src.rpm//g"`
	if [[ -n vnum ]]
	then
		echo "File not found."
		return 1
	fi
	echo "Most recent appears to be $vnum"

	repo="testing"
	if (($+2))
	then
		repo="$2"
	fi

	rpm --resign SRPMS/$1-$vnum.src.rpm RPMS/sparc64/$1*$vnum* && scp SRPMS/$1-$vnum.src.rpm RPMS/sparc64/$1*$vnum* rpm:/rpm/CHECK_PEND.$repo
	popd &> /dev/null
}

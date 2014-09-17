# HDNET Shell Essentials

BREWPREFIX="$(brew --prefix)"

#### Completion
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

# If possible, add tab completion for many more commands
[ -f /etc/bash_completion ] && source /etc/bash_completion
[ -f ${BREWPREFIX}/etc/bash_completion ] && source ${BREWPREFIX}/etc/bash_completion

#### load inputrc
bind -f ${BREWPREFIX}/etc/bash/hdnet-inputrc

#### load prompt
source ${BREWPREFIX}/etc/bash/hdnet-prompt

#### Aliase
alias nano="nano -w"
alias sf-up="git-up && composer install && app/console assetic:dump && app/console cache:clear && app/console doctrine:schema:update --force"
alias p="cd /Volumes/Projekte"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

#### PATH
export PATH="${BREWPREFIX}/sbin:$PATH"

if [ -d $HOME/.composer/vendor/bin ]
then
	export PATH="$HOME/.composer/vendor/bin:$PATH"
fi

#### Exports
export EDITOR="nano -w"

# Larger bash history (allow 32³ entries; default is 500)
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups
# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help:xml *:history *:[ \t]*"

# Highlight section titles in manual pages
export LESS_TERMCAP_md="$ORANGE"

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

# Always enable colored `grep` output
export GREP_OPTIONS="--color=auto"

# Always enable colored `ls` output
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

#### Functions
# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$@"
}

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}

# `o` with no arguments opens current directory, otherwise opens the given
# location
function o() {
	if [ $# -eq 0 ]; then
		open .
	else
		open "$@"
	fi
}

# Textwrangler oeffnen
function tw() {
	open -a TextWrangler $*
}

sTree()
{
    open -a SourceTree $*
}

xml()
{
    echo $1 | xmllint --format -
}

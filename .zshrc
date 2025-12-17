# Personal aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Git aliases
alias gca='git commit -am'
alias gcam='git commit -a --amend'

# Personal functions
dbtd() {
    dbt build "$@" --defer --state prd_target/target/
}


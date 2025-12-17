alias a='php artisan '

alias migrate='php artisan migrate'

alias mfs='php artisan migrate:fresh --seed'

alias mysql='mysql -u root -p'

alias work='cd ~/Workspace/11degrees/'
alias api='cd ~/Workspace/11degrees/winguhr-api'
alias frontend='cd ~/Workspace/11degrees/winguhr-frontend'

mkcd() {
  mkdir "$1"
  cd "$1"
}

#git
alias gs='git status'
alias gaa='git add .'
alias pull='git pull'
alias push='git push'
alias push-all='git push origin main && git push origin develop && git push --tags'

alias vim='nvim'

export EDITOR="nvim"
# Editor used by CLI
export SUDO_EDITOR="$EDITOR"

alias ls='ls -al'

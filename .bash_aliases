alias a='php artisan '

alias migrate='php artisan migrate'

alias mfs='php artisan migrate:fresh --seed'

alias mysql='mysql -u root -p'

alias personal='cd ~/Workspace/personal/Projects/'
alias work='cd ~/Workspace/11degrees/'
alias api='cd ~/Workspace/11degrees/winguhr-api'
alias frontend='cd ~/Workspace/11degrees/winguhr-frontend'

alias w='tmuxinator start winguhr'
alias wq='tmuxinator stop winguhr'

alias taskflow='cd ~/Workspace/personal/Projects/taskflow/'
alias t='tmuxinator start taskflow'

export API="/Users/dickson/Workspace/11degrees/winguhr-api"
export FRONTEND="/Users/dickson/Workspace/11degrees/winguhr-frontend"

export JUBILEE_BACKEND="/Users/dickson/Workspace/shinrai/jubilee_life_portal_backend"
export JUBILEE_FRONTEND="/Users/dickson/Workspace/shinrai/jubilee_life_portal_frontend/life_portal"

alias j='tmuxinator start jubilee'
alias jq='tmuxinator stop jubilee'

export TASKFLOW="/Users/dickson/Workspace/personal/Projects/taskflow"
export TASKFLOW_BACKEND="/Users/dickson/Workspace/personal/Projects/taskflow/backend"
export TASKFLOW_FRONTEND="/Users/dickson/Workspace/personal/Projects/taskflow/frontend"

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

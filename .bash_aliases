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

export JUBILEE_BACKEND="/Users/dickson/Workspace/shinrai/jubilee_life_portal_backend_tz"
export JUBILEE_FRONTEND="/Users/dickson/Workspace/shinrai/jubilee_life_portal_frontend_TZ/life_portal"

export JUBILEE_BACKEND_KE="/Users/dickson/Workspace/shinrai/jubilee_life_portal_backend"
export JUBILEE_FRONTEND_KE="/Users/dickson/Workspace/shinrai/jubilee_life_portal_frontend/life_portal"

alias j='tmuxinator start jubilee'
alias jq='cd $JUBILEE_BACKEND && docker compose down && tmuxinator stop jubilee'

alias k='tmuxinator start jubilee_ke'
alias kq='cd $JUBILEE_BACKEND_KE && docker compose down && tmuxinator stop jubilee_ke'

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

alias npm='sfw npm'
alias npx='sfw npx'

dcl() {
  declare -A services=(
    [user]="user_service"
    [integration]="integration_gateway"
    [auth]="auth_service"
    [product]="product_service"
    [policy]="policy_service"
    [notification]="notification_service"
    [document]="document_service"
  )

  local args=()
  for arg in "$@"; do
    args+=("${services[$arg]:-$arg}")
  done

  docker compose logs -f "${args[@]}"
}

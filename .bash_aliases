alias a='php artisan '

alias migrate='php artisan migrate'

alias mfs='php artisan migrate:fresh --seed'

alias mysql='mysql -u root -p'

alias gaa='git add .'

alias cm='make commit'

alias gs='git status'

alias brightness='sudo su -c "echo 20 >/sys/class/backlight/intel_backlight/brightness"'

alias bref-cli='vendor/bin/bref cli hrms-staging-artisan -r eu-west-1'

alias work='cd ~/Code/Work'

alias personal='cd ~/Code/Personal/Projects'

mkcd() {
	mkdir "$1"
	cd "$1"
}

alias dns='make dns'

alias cl='clear'

alias dep='vendor/bin/dep'

alias fj='functional-javascript-workshop'

alias verify='fj verify'

alias run='fj run'

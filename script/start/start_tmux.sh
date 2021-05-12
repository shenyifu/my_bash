#/bin/sh
tmux new-session -d -s work
# index 1 window control
tmux rename-window cont
tmux send-keys -t cont "sudo service apache2 stop && sudo service nginx start" C-m
# index 2 window prome
tmux new-window -n prom
tmux send-keys -t work:prom "cd /var/www/http" C-m

#!/bin/bash
SSH_REDIR_PORT=10000
SSH_D="tunnel@mon_ip -p 1022"
COMMAND="ssh -R $SSH_REDIR_PORT:localhost:22 $SSH_D -N -f"
pgrep -f "ssh -R $SSH_REDIR_PORT:localhost:22" > /dev/null 2>&1 || (eval $COMMAND && echo $COMMAND)

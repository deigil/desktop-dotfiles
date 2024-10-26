function ssh_agent_start
    if not test -f ~/.ssh/agent.env
        ssh-agent -c > ~/.ssh/agent.env
        chmod 600 ~/.ssh/agent.env
    end

    source ~/.ssh/agent.env >/dev/null

    # Check if agent is running
    if not ps -p $SSH_AGENT_PID >/dev/null
        # Start new agent
        ssh-agent -c > ~/.ssh/agent.env
        chmod 600 ~/.ssh/agent.env
        source ~/.ssh/agent.env >/dev/null
    end

    # Add default keys if they exist
    ssh-add ~/.ssh/github 2>/dev/null
end
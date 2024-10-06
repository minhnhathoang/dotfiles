#!/bin/bash

# Get the list of workspaces in JSON format
workspaces=$(i3-msg -t get_workspaces)

# Parse the JSON and iterate over each workspace
echo "$workspaces" | jq -c '.[]' | while read -r workspace; do
    if [ "$(echo "$workspace" | jq '.focused')" = "true" ]; then
        number=$(echo "$workspace" | jq -r '.name | split(":")[0]')
        name=$(echo "" | dmenu -p "Rename workspace ${number}:")

        if [ -n "$name" ]; then
            name=$(echo "$name" | xargs)  # Trim whitespace
            if [ -n "$name" ]; then
                name=":${name}"
            fi
            i3-msg "rename workspace to \"${number}${name}\""
        fi
    fi
done

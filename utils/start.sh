#!/bin/bash

# Sets the Java path to /usr/bin/java
JAVA_PATH="/usr/bin/java"

# Starts the server!
tmux new-session -s docker-minecraft "$JAVA_PATH $JAVA_FLAGS -Xms$MEMORY -Xmx$MEMORY -jar paper.jar --nojline"

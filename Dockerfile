# Setup runtime environment 
FROM ubuntu:22.04
RUN apt-get update -y && apt-get install -y curl jq tmux

# Set default version and working directory
ARG version=1.20.2
WORKDIR /home/docker-minecraft

# Copy and run getpaper script
COPY utils/getpaper.sh .
RUN chmod +x getpaper.sh && ./getpaper.sh ${version}
RUN rm ./getpaper.sh

# Create a non-root user (docker-minecraft)
RUN useradd -m -d /home/docker-minecraft -s /bin/bash docker-minecraft

# Declare the version ARG again for this stage
ARG version

# Install appropriate Java version
RUN apt-get update && apt-get install -y bc; \
    if [ $(echo "${version} < 1.12.2" | bc -l) -eq 1 ]; then \
      apt-get install -y openjdk-8-jre-headless; \
    elif [ $(echo "${version} < 1.16.5" | bc -l) -eq 1 ]; then \
      apt-get install -y openjdk-11-jre-headless; \
    else \
      apt-get install -y openjdk-17-jre-headless; \
    fi && apt-get clean 

# Expose Minecraft port
EXPOSE 25565/tcp
EXPOSE 25565/udp

# Set Java flags and memory size
ARG memory=2G
ENV MEMORY=$memory
ENV JAVAFLAGS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"

# Copy preliminary files and make start.sh executable
COPY requisites/eula.txt . 
COPY requisites/server.properties .
COPY utils/start.sh .

RUN chmod +x start.sh

# Change ownership of files to the non-root user
RUN chown -R docker-minecraft:docker-minecraft /home/docker-minecraft

# Start the server using start.sh as the non-root user
USER docker-minecraft
CMD ["./start.sh"]

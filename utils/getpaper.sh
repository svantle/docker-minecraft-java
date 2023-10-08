#!/bin/bash

# Set default version to 1.20.2 if not provided
PAPER_VERSION=${1:-1.20.2}

# Fetch the latest build and download URL from specified version
LATEST_BUILD=$(curl -s "https://papermc.io/api/v2/projects/paper/versions/${PAPER_VERSION}" | jq '.builds[-1]')
PAPER_DOWNLOAD_URL="https://papermc.io/api/v2/projects/paper/versions/${PAPER_VERSION}/builds/${LATEST_BUILD}/downloads/$(curl -s "https://papermc.io/api/v2/projects/paper/versions/${PAPER_VERSION}/builds/${LATEST_BUILD}" | jq -r '.downloads.application.name')"

# Download the paper.jar
curl -s -o paper.jar "$PAPER_DOWNLOAD_URL"

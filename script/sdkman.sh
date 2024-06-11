#!/usr/bin/env bash

curl -s "https://get.sdkman.io" | bash
source ~/.sdkman/bin/sdkman-init.sh
sdk install maven
sdk install gradle
sdk install java 17.0.9-oracle
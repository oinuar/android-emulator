FROM ubuntu

# Expose ADB, ADB control and VNC ports
EXPOSE 5037
EXPOSE 5554
EXPOSE 5555
EXPOSE 5900

ENV DEBIAN_FRONTEND noninteractive
RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

# Update packages
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install software-properties-common bzip2 net-tools socat && \
    add-apt-repository ppa:webupd8team/java && \
    apt-get update -y && \
    apt-get -y --no-install-recommends install oracle-java8-installer && \
    rm -rf /var/lib/apt/lists/*

# Install android sdk
RUN wget -qO- http://dl.google.com/android/android-sdk_r23-linux.tgz | \
    tar xvz -C /usr/local/ && \
    mv /usr/local/android-sdk-linux /usr/local/android-sdk && \
    chown -R root:root /usr/local/android-sdk/

# Add android tools and platform tools to PATH
ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools

# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

# Install latest android tools and system images
RUN ( sleep 4 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk --no-ui --force -a --filter \
    platform-tool,android-19,sys-img-x86-android-19 && \
    echo "y" | android update adb

# Create fake keymap file
RUN mkdir /usr/local/android-sdk/tools/keymaps && \
    touch /usr/local/android-sdk/tools/keymaps/en-us

ENV NOTVISIBLE "in users profile"
ENV ANDROID_PLATFORM "android-19"
ENV ANDROID_ARCH "x86"

# Add entrypoint
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

FROM debian:jessie-backports

MAINTAINER Michael Holloway <mdh@hollowlog.co>

ENV DEBIAN_FRONTEND noninteractive

# Install OpenJDK 8 & other prereqs
RUN apt-get -y update && \
    apt-get -y install wget unzip git libqt5widgets5 kvm qemu-kvm libvirt-bin virtinst virt-viewer && \
    apt-get -y -t jessie-backports install openjdk-8-jre-headless ca-certificates-java && \
    apt-get -y install openjdk-8-jdk

# Install android sdk
ARG ANDROID_SDK_VERSION=25.2.5
RUN cd /opt && wget https://dl.google.com/android/repository/tools_r${ANDROID_SDK_VERSION}-linux.zip \
    && unzip tools_r${ANDROID_SDK_VERSION}-linux.zip \
    && rm -f tools_r${ANDROID_SDK_VERSION}-linux.zip \
    && mkdir android-sdk && mv tools android-sdk/tools

# Add android tools and platform tools to PATH
ENV ANDROID_HOME /opt/android-sdk
ENV PATH ${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${PATH}

# Install latest android tools and system images
RUN echo y | android update sdk -u -a -t platform-tools \
    && echo y | android update sdk -u -a -t build-tools-25.0.3 \
    && echo y | android update sdk -u -a -t android-24 \
    && echo y | android update sdk -u -a -t android-25 \
    # && echo y | android update sdk -u -a -t sys-img-x86-android-24 \ // todo: add and make configurable
    && echo y | android update sdk -u -a -t sys-img-armeabi-v7a-android-24

# Create fake keymap file
RUN mkdir /opt/android-sdk/tools/keymaps && \
    touch /opt/android-sdk/tools/keymaps/en-us

# Add volume
VOLUME /workspace
WORKDIR /workspace

# Add entrypoint
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

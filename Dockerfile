FROM openjdk:8-jdk

ARG ANDROID_SDK_TOOLS="3859397"
ARG ANDROID_BUILD_TOOLS="27.0.3"
ARG ANDROID_COMPILE_SDK="24"
ARG FLUTTER_VERSION="0.3.1-beta"

RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 locales
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip
RUN unzip android-sdk.zip -d android-sdk-linux && rm -f android-sdk.zip
RUN yes | android-sdk-linux/tools/bin/sdkmanager --licenses
RUN android-sdk-linux/tools/bin/sdkmanager "platform-tools" "platforms;android-${ANDROID_COMPILE_SDK}" "build-tools;${ANDROID_BUILD_TOOLS}" --sdk_root="android-sdk-linux"

RUN echo "en_US UTF-8" > /etc/locale.gen
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales -f noninteractive -p critical
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en

RUN wget --quiet --output-document=flutter.tar.xz https://storage.googleapis.com/flutter_infra/releases/beta/linux/flutter_linux_v${FLUTTER_VERSION}.tar.xz
RUN tar xf flutter.tar.xz && rm -f flutter.tar

ENV ANDROID_HOME=$PWD/android-sdk-linux
ENV PATH="$PWD/flutter/bin:$PWD/android-sdk-linux/platform-tools/:${PATH}"

RUN flutter doctor

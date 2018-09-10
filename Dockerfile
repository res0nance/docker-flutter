FROM openjdk:8-jdk-slim

ARG ANDROID_SDK_TOOLS="4333796"
ARG ANDROID_BUILD_TOOLS="27.0.3"
ARG ANDROID_COMPILE_SDK="24"
ARG FLUTTER_VERSION="0.7.3-beta"

RUN \
  apt-get update -qq && \
  apt-get install -qq git wget tar unzip lib32stdc++6 lib32z1 locales libglu1-mesa > /dev/null

RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales -f noninteractive -p critical
ENV LANG=en_US.UTF-8

RUN wget -qq --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip && \
    unzip -qq android-sdk.zip -d android-sdk-linux && rm -f android-sdk.zip
RUN mkdir ~/.android
RUN touch ~/.android/repositories.cfg
RUN yes | android-sdk-linux/tools/bin/sdkmanager --licenses > /dev/null
RUN android-sdk-linux/tools/bin/sdkmanager "platform-tools" "platforms;android-${ANDROID_COMPILE_SDK}" "build-tools;${ANDROID_BUILD_TOOLS}" --sdk_root="android-sdk-linux"

RUN wget -qq --output-document=flutter-sdk.tar.xz https://storage.googleapis.com/flutter_infra/releases/beta/linux/flutter_linux_v${FLUTTER_VERSION}.tar.xz && \
    tar xf flutter-sdk.tar.xz && rm -f flutter-sdk.tar.xz

ENV ANDROID_HOME=$PWD/android-sdk-linux
ENV PATH="$PWD/flutter/bin:$PWD/android-sdk-linux/platform-tools/:${PATH}"

RUN flutter doctor

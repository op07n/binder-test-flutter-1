FROM jupyter/scipy-notebook:45f07a14b422


ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

WORKDIR ${HOME}

USER root

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

# RUN apt-get install -y --no-install-recommends git vim wget unzip sudo xserver-xorg openjdk-11-jre cmake libtool pkg-config autogen ocaml ocamlbuild bison flex texinfo python-dev python-mako python-six swig3.0 python3-mako python3-numpy

RUN apt-get install -y --no-install-recommends curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget
 

USER ${USER}
WORKDIR /home/${NB_USER}


# Prepare Android directories and system variables
RUN mkdir -p /home/${NB_USER}/Android/sdk
ENV ANDROID_SDK_ROOT /home/${NB_USER}/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg

# Set up Android SDK
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
ENV PATH "$PATH:/home/${NB_USER}/Android/sdk/platform-tools"



# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/${NB_USER}/flutter/bin"
   
RUN flutter doctor




RUN chown -R ${NB_UID} ${HOME}
USER ${USER}

WORKDIR ${HOME}/





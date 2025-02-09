FROM --platform=linux/arm64/v8 pjongy/myde:5.0.0-arm

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=root
ENV USERNAME=$USERNAME
ARG HOME_PATH=/root
ENV HOME_PATH=$HOME_PATH
ARG INSTALL_PATH=/root/installed
ENV INSTALL_PATH=$INSTALL_PATH

RUN apt -y install socat gdb git gcc

# Install gef (gdb enhanced feature)
RUN apt install file -y && \
  wget -O $INSTALL_PATH/.gdbinit-gef.py -q https://gef.blah.cat/py && \
  echo source $INSTALL_PATH/.gdbinit-gef.py >> $HOME_PATH/.gdbinit

# Install netcat, stract, ltrace
RUN apt install ncat strace ltrace -y

# Install volatility
RUN git clone https://github.com/volatilityfoundation/volatility3 $INSTALL_PATH/volatility3 && \
  echo "alias volatility='python3 $INSTALL_PATH/volatility3/vol.py'" >> ~/.zshrc

# Install one_gadget
RUN apt-get install ruby-full -y && \
  gem install one_gadget

# Install radare2
RUN git clone https://github.com/radareorg/radare2 $INSTALL_PATH/radare2 \
  && $INSTALL_PATH/radare2/sys/install.sh
RUN apt-get install meson ninja-build cmake -y \
  && pip3 install meson==1.7.0 # meson does not need to be reinsall when python is reinstalled
# Install radare2 ghidra plugin
RUN r2pm -U && \
  r2pm -ci r2ghidra
# Install radare2 decompile plugin
RUN r2pm -ci r2dec

#
# Install metasploit
RUN curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall
RUN rm -f msfinstall && \
 echo alias msf=/opt/metasploit-framework/bin/msfconsole >> ~/.zshrc

#
# Install jadx
RUN wget -O $INSTALL_PATH/jadx.zip https://github.com/skylot/jadx/releases/download/v1.3.3/jadx-1.3.3.zip && \
 unzip $INSTALL_PATH/jadx.zip -d /opt/jadx/ && \
 chmod -R 755 /opt/jadx/bin/ && \
 echo alias jadx=/opt/jadx/bin/jadx >> ~/.zshrc

#
# Install binwalk
RUN cargo install binwalk

#
# Install ghidra (not releated with r2ghidra, for ghidriff, ghidrecomp)
# NOTE: ghidra 11.3 allows jdk 21+, to be precise explicitly, install 21, Y for set as default
RUN echo "yes "Y" | sdk install java 21.0.6-zulu" >> $INSTALL_PATH/installer/jdk.sh
# Install ghidra
RUN $INSTALL_PATH/installer/jdk.sh
RUN git clone https://github.com/NationalSecurityAgency/ghidra.git $INSTALL_PATH/ghidra \
  && cd $INSTALL_PATH/ghidra && git checkout Ghidra_11.3_build
RUN cd $INSTALL_PATH/ghidra \
  && JAVA_HOME=$HOME_PATH/.sdkman/candidates/java/current ./gradlew -I gradle/support/fetchDependencies.gradle \
  && JAVA_HOME=$HOME_PATH/.sdkman/candidates/java/current ./gradlew buildGhidra
# NOTE: dist/ghidra_11.3_YYYYMMDD.zip
RUN ouch decompress $INSTALL_PATH/ghidra/build/dist/ghidra_11.3*.zip --dir $INSTALL_PATH
ENV GHIDRA_INSTALL_DIR=$INSTALL_PATH/ghidra_11.3_DEV

# Install dependencies for pwntool, angr (will be installed by installer)
RUN apt-get -y install libssl-dev libffi-dev build-essential

#
# Install python modules
# Install pwntools
# Install angr
# Install ghidriff and ghidremp
RUN echo "python3 -m pip install meson==1.7.0" >> $INSTALL_PATH/installer/python.sh \
  && echo "python3 -m pip install pwntools==4.13.0" >> $INSTALL_PATH/installer/python.sh \
  && echo "python3 -m pip install angr==9.2.115" >> $INSTALL_PATH/installer/python.sh \
  && echo "python3 -m pip install ghidriff==0.7.3" >> $INSTALL_PATH/installer/python.sh \
  && echo "python3 -m pip install ghidrecomp==0.5.5" >> $INSTALL_PATH/installer/python.sh

RUN $INSTALL_PATH/installer/python.sh

RUN echo alias ghidriff=\"python3 -m ghidriff\" >> ~/.zshrc && \
  echo alias ghidrecomp=\"python3 -m ghidrecomp\" >> ~/.zshrc


COPY --chown=$USERNAME ./HELP.mysece $HOME_PATH/HELP.mysece
RUN cat $HOME_PATH/HELP.mysece >> $HOME_PATH/HELP && \
 rm $HOME_PATH/HELP.mysece

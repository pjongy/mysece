FROM pjongy/myde:5.0.0-amd64

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=dev
ENV USERNAME=$USERNAME
ARG INSTALL_PATH=/home/$USERNAME/installed
ENV INSTALL_PATH=$INSTALL_PATH

RUN sudo dpkg --add-architecture i386 && \
 sudo apt-get -y update --fix-missing && sudo apt-get -y upgrade && \
 sudo apt-get -y install libc6:i386 libstdc++6:i386 && \
 sudo apt-get -y install socat gdb git gcc && \
 sudo apt-get -y install gcc-multilib

# Install gef (gdb enhanced feature)
RUN sudo apt install file -y && \
  wget -O $INSTALL_PATH/.gdbinit-gef.py -q https://gef.blah.cat/py && \
  echo source $INSTALL_PATH/.gdbinit-gef.py >> ~/.gdbinit
RUN sudo cp ~/.gdbinit /root/.gdbinit  # setup for gdb with root

# Install netcat, stract, ltrace
RUN sudo apt install ncat strace ltrace -y

# Install volatility
RUN git clone https://github.com/volatilityfoundation/volatility3 $INSTALL_PATH/volatility3 && \
  echo "alias volatility='python3 $INSTALL_PATH/volatility3/vol.py'" >> ~/.zshrc

# Install one_gadget
RUN sudo apt-get install ruby-full -y && \
  sudo gem install one_gadget

# Install radare2
RUN git clone https://github.com/radareorg/radare2 $INSTALL_PATH/radare2 \
  && $INSTALL_PATH/radare2/sys/install.sh
RUN sudo apt-get install meson ninja-build cmake -y \
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
 sudo unzip $INSTALL_PATH/jadx.zip -d /opt/jadx/ && \
 sudo chmod -R 755 /opt/jadx/bin/ && \
 echo alias jadx=/opt/jadx/bin/jadx >> ~/.zshrc

#
# Install binwalk
RUN cargo install binwalk

#
# Install ghidra (not releated with r2ghidra, for ghidriff, ghidrecomp)
# NOTE: ghidra allows jdk 17+, to be precise explicitly, install 17, Y for set as default
RUN echo "yes "Y" | sdk install java 17.0.14-zulu" >> $INSTALL_PATH/installer/jdk.sh
# Install ghidra
RUN $INSTALL_PATH/installer/jdk.sh
RUN wget -O $INSTALL_PATH/ghidra_11.1.2.zip \
  https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.1.2_build/ghidra_11.1.2_PUBLIC_20240709.zip
RUN ouch decompress $INSTALL_PATH/ghidra_11.1.2.zip --dir $INSTALL_PATH/ghidra_11.1.2/
ENV GHIDRA_INSTALL_DIR=$INSTALL_PATH/ghidra_11.1.2/ghidra_11.1.2_PUBLIC

# Install dependencies for pwntool, angr (will be installed by installer)
RUN sudo apt-get -y install libssl-dev libffi-dev build-essential

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


COPY --chown=$USERNAME ./HELP.mysece /home/$USERNAME/HELP.mysece
RUN cat /home/$USERNAME/HELP.mysece >> /home/$USERNAME/HELP && \
 rm ~/HELP.mysece

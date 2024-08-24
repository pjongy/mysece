FROM pjongy/myde:4.6.0

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=dev
ENV USERNAME=$USERNAME
ARG INSTALL_PATH=/home/$USERNAME/installed
ENV INSTALL_PATH=$INSTALL_PATH

# Update alternatives for python
ARG PYTHON_VERSION=3.12.0
RUN sudo update-alternatives --install /usr/bin/python3 python3 $HOME/.pyenv/versions/$PYTHON_VERSION/bin/python3 100 --force && \
 sudo update-alternatives --install /usr/bin/pip3 pip3 $HOME/.pyenv/versions/$PYTHON_VERSION/bin/pip3 100 --force

RUN sudo dpkg --add-architecture i386 && \
 sudo apt-get -y update --fix-missing && sudo apt-get -y upgrade && \
 sudo apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386 && \
 sudo apt-get -y install socat gdb git gcc && \
 sudo apt-get -y install gcc-multilib

RUN sudo git clone https://github.com/longld/peda.git $INSTALL_PATH/peda && \
 sudo git clone https://github.com/scwuaptx/Pwngdb.git $INSTALL_PATH/pwngdb
# gdb init setup to use pwngdb
RUN echo "source $INSTALL_PATH/peda/peda.py" > ~/.gdbinit && \
 echo "source $INSTALL_PATH/pwngdb/pwngdb.py" >> ~/.gdbinit && \
 echo "source $INSTALL_PATH/pwngdb/angelheap/gdbinit.py" >> ~/.gdbinit && \
 echo "define hook-run" >> ~/.gdbinit && \
 echo "python" >> ~/.gdbinit && \
 echo "import angelheap" >> ~/.gdbinit && \
 echo "angelheap.init_angelheap()" >> ~/.gdbinit && \
 echo "end" >> ~/.gdbinit && \
 echo "end" >> ~/.gdbinit

# Install gef (gdb enhanced feature)
RUN sudo apt install file -y && \
  wget -O $INSTALL_PATH/.gdbinit-gef.py -q https://gef.blah.cat/py && \
  echo source $INSTALL_PATH/.gdbinit-gef.py >> ~/.gdbinit
RUN sudo cp ~/.gdbinit /root/.gdbinit

RUN sudo apt install netcat -y && sudo apt install strace ltrace -y

RUN git clone https://github.com/volatilityfoundation/volatility3 $INSTALL_PATH/volatility3 && \
  echo "alias volatility='python3 $INSTALL_PATH/volatility3/vol.py'" >> ~/.zshrc

RUN sudo apt-get install ruby-full -y && \
  sudo gem install one_gadget

RUN git clone https://github.com/radareorg/radare2 $INSTALL_PATH/radare2 &&\
  $INSTALL_PATH/radare2/sys/install.sh && \
  sudo apt install cmake -y

# Install radare2 ghidra plugin
RUN r2pm -u && \
  r2pm -ci r2ghidra

# Install radare2 decompile plugin
RUN sudo apt-get install meson ninja-build -y && pip3 install meson
RUN r2pm -ci r2dec

#
# Install python modules
RUN python3 -m pip install --upgrade pip
# Install pwntools
RUN sudo apt-get -y install libssl-dev libffi-dev build-essential
RUN python3 -m pip install pwntools==4.13.0
# Install angr
RUN python3 -m pip install angr==9.2.115

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
RUN git clone https://github.com/ReFirmLabs/binwalk.git $INSTALL_PATH/binwalk &&\
  cd $INSTALL_PATH/binwalk &&\
  python3 setup.py install &&\
  echo alias binwalk=\"python3 -m binwalk\" >> ~/.zshrc
# sqaushfs dependencies
# original is https://github.com/devttys0/sasquatch but build failed (ref. https://github.com/devttys0/sasquatch/pull/47)
RUN sudo apt-get install build-essential liblzma-dev liblzo2-dev zlib1g-dev -y
RUN git clone https://github.com/threadexio/sasquatch.git $INSTALL_PATH/sasquatch &&\
  cd $INSTALL_PATH/sasquatch &&\
  git checkout 82da12efe97a37ddcd33dba53933bc96db4d7c69 &&\
  ./build.sh

# Update jdk version to use ghidra 11.1
RUN ~/.jabba/bin/jabba install openjdk@1.17.0
ENV JAVA_HOME=/home/dev/.jabba/jdk/openjdk@1.17.0
ENV PATH="$JAVA_HOME/bin:$PATH"

# Install ghidra
RUN wget -O $INSTALL_PATH/ghidra_11.1.2.zip \
  https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.1.2_build/ghidra_11.1.2_PUBLIC_20240709.zip
RUN ouch decompress $INSTALL_PATH/ghidra_11.1.2.zip --dir $INSTALL_PATH/ghidra_11.1.2/

# Install ghidriff and ghidremp
ENV GHIDRA_INSTALL_DIR=$INSTALL_PATH/ghidra_11.1.2/ghidra_11.1.2_PUBLIC
RUN pip3 install ghidriff && pip3 install ghidrecomp
RUN echo alias ghidriff=\"python3 -m ghidriff\" >> ~/.zshrc && \
  echo alias ghidrecomp=\"python3 -m ghidrecomp\" >> ~/.zshrc

COPY --chown=$USERNAME ./HELP.mysece /home/$USERNAME/HELP.mysece
RUN cat /home/$USERNAME/HELP.mysece >> /home/$USERNAME/HELP && \
 rm ~/HELP.mysece

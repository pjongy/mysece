FROM pjongy/myde:0.1.0

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=dev
ARG INSTALL_PATH=/home/$USERNAME/installed
ENV INSTALL_PATH $INSTALL_PATH

RUN sudo dpkg --add-architecture i386
RUN sudo apt-get -y update --fix-missing && sudo apt-get -y upgrade
RUN sudo apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386
RUN sudo apt-get -y install socat gdb git gcc vim
RUN sudo apt-get -y install gcc-multilib

RUN sudo git clone https://github.com/pwndbg/pwndbg $INSTALL_PATH/pwndbg
RUN cd $INSTALL_PATH/pwndbg && ./setup.sh
RUN sudo git clone https://github.com/longld/peda.git $INSTALL_PATH/peda
RUN sudo git clone https://github.com/scwuaptx/Pwngdb.git $INSTALL_PATH/pwngdb
# gdb init setup to use pwngdb
RUN echo "source $INSTALL_PATH/peda/peda.py" > ~/.gdbinit
RUN echo "source $INSTALL_PATH/pwngdb/pwngdb.py" >> ~/.gdbinit
RUN echo "source $INSTALL_PATH/pwngdb/angelheap/gdbinit.py" >> ~/.gdbinit
RUN echo "define hook-run" >> ~/.gdbinit
RUN echo "python" >> ~/.gdbinit
RUN echo "import angelheap" >> ~/.gdbinit
RUN echo "angelheap.init_angelheap" >> ~/.gdbinit
RUN echo "end" >> ~/.gdbinit
RUN echo "end" >> ~/.gdbinit

RUN sudo apt install netcat -y
RUN sudo apt-get -y install libssl-dev libffi-dev build-essential
RUN python3 -m pip install --upgrade pwntools

RUN git clone https://github.com/volatilityfoundation/volatility3 $INSTALL_PATH/volatility3
RUN echo "alias volatility='python3 $INSTALL_PATH/volatility3/vol.py'" >> ~/.zshrc

RUN sudo apt-get install ruby-full -y
RUN sudo gem install one_gadget

RUN git clone https://github.com/radareorg/radare2 $INSTALL_PATH/radare2
RUN $INSTALL_PATH/radare2/sys/install.sh

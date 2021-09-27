FROM pjongy/myde:0.1.0

ENV DEBIAN_FRONTEND=noninteractive

RUN sudo dpkg --add-architecture i386
RUN sudo apt-get -y update --fix-missing && sudo apt-get -y upgrade
RUN sudo apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386
RUN sudo apt-get -y install socat gdb git gcc vim
RUN sudo apt-get -y install gcc-multilib

WORKDIR /home/dev/
RUN sudo git clone https://github.com/pwndbg/pwndbg
RUN cd pwndbg && ./setup.sh
RUN sudo git clone https://github.com/longld/peda.git
RUN sudo git clone https://github.com/scwuaptx/Pwngdb.git
RUN cp ./Pwngdb/.gdbinit ~/

RUN sudo apt install netcat -y
RUN sudo apt-get -y install libssl-dev libffi-dev build-essential
RUN python3 -m pip install --upgrade pwntools

RUN git clone https://github.com/volatilityfoundation/volatility3
RUN echo "alias volatility='python3 ~/volatility3/vol.py'" >> ~/.zshrc

RUN sudo apt-get install ruby-full -y
RUN sudo gem install one_gadget

RUN git clone https://github.com/radareorg/radare2
RUN ./radare2/sys/install.sh

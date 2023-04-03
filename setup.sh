#!/bin/bash
#
# A script to setup my Kali environment
# sudo bash setup.sh

# Update and install
apt update
apt install terminator tmux ghidra xclip

# Basic aliases
echo "alias set-clip='xclip -selection clipboard'" >> /home/kali/.zshrc

# Tmux & Vim configs
cp ./.tmux.conf /home/kali/
cp ./.vimrc /home/kali/

# Pwndbg + GEF + Peda
cd /home/kali/
mkdir opt
cd /home/kali/opt

git clone https://github.com/pwndbg/pwndbg
cd pwndbg
./setup.sh
cd ..
mv pwndbg /home/kali/opt/pwndbg-src
echo "source /home/kali/opt/pwndbg-src/gdbinit.py" > /home/kali/opt/.gdbinit_pwndbg

git clone https://github.com/longld/peda.git /home/kali/opt/peda

wget -q -O /home/kali/opt/.gdbinit-gef.py https://raw.githubusercontent.com/hugsy/gef/dev/gef.py
echo source /home/kali/opt/.gdbinit-gef.py >> /home/kali/.gdbinit

echo "define init-peda
source /home/kali/opt/peda/peda.py
end
document init-peda
Initializes the PEDA (Python Exploit Development Assistant for GDB) framework
end

define init-pwndbg
source /home/kali/opt/.gdbinit_pwndbg
end
document init-pwndbg
Initializes PwnDBG
end

define init-gef
source /home/kali/opt/.gdbinit-gef.py
end
document init-gef
Initializes GEF (GDB Enhanced Features)
end" > /home/kali/.gdbinit

echo '#!/bin/sh
exec gdb -q -ex init-peda "$@"' > /usr/bin/gdb-peda

echo '#!/bin/sh
exec gdb -q -ex init-pwndbg "$@"' > /usr/bin/gdb-pwndbg

echo '#!/bin/sh
exec gdb -q -ex init-gef "$@"' > /usr/bin/gdb-gef

chmod +x /usr/bin/gdb-*

# Ghidra-auto
cp /home/kali/configs/ghidra-auto.py /usr/bin/ghidra-auto
chmod +x /usr/bin/ghidra-auto

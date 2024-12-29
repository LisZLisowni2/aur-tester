FROM archlinux:latest
RUN pacman -Syu --noconfirm 
RUN pacman -S --noconfirm linux base linux-firmware less bash base-devel git shellcheck clamav rkhunter cmake make 
RUN useradd -m buildtest && echo "buildtest ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers 
WORKDIR /home/buildtest/app
COPY . /home/buildtest/app 
RUN ls -al /home/buildtest/app && cmake . && make && make install
RUN chown -R buildtest /home/buildtest/
ENTRYPOINT ["aurtester"]
